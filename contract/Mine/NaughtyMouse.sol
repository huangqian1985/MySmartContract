// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721psi/contracts/ERC721Psi.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

    error CallerIsContract();
    error PublicMintIsNotBegin();
    error ReachMaxSupply();
    error MintMoreThanAllowed();
    error NeedSendMoreETH();
    error NotInWhiteList();
    error MintStop();
    error NoMoreBalance();

/**
 @author DAO Labs
 @title NaughtyMouse NFT
 */
contract NaughtyMouseNFT is ERC721Psi, Ownable {

    enum WhiteListType {
        NONE,
        DEV,
        NORMAL
    }

    struct WithDrawInfo {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    event SubmitWithDraw(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmWithDraw(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteWithDraw(address indexed owner, uint indexed txIndex);

    mapping(address => uint256) public _numberMinted;

    uint256 public publicMintStartTime = 0xFFFFFFFF;

    uint256 public constant MINT_PRICE = 0.001 ether;

    uint256 public constant DevWhiteListMintMaxCount = 10;
    uint256 public constant NormalWhiteListMintMaxCount = 1;

    uint256 public immutable MintMaxSize;

    bool public IsMinting = true;

    bytes32 public devWhiteListRoot = 0x0;
    bytes32 public normalWhiteListRoot = 0x0;

    /*
        multi-sig variable start
    */
    address[] public confirmers;
    mapping(address => bool) private isConfirmer;
    uint256 public numConfirmationsRequired;

    // mapping from tx index => owner => bool
    mapping(uint => mapping(address => bool)) public withDrawConfirmRecord;

    WithDrawInfo[] public withDrawList;

    //
    constructor(address[] memory _confirmers, uint256 _numConfirmationsRequired, uint256 mintMaxSize_) ERC721Psi("NaughtyMouse NFT", "NaughtyMouse") {
        require(_confirmers.length > 0, "confirmers length is empty");
        require(
            _numConfirmationsRequired > 0 &&
            _numConfirmationsRequired <= _confirmers.length,
            "invalid number of required confirmations"
        );

        for (uint i = 0; i < _confirmers.length; i++) {
            address confirmer = _confirmers[i];

            require(confirmer != address(0), "invalid confirmer");
            require(!isConfirmer[confirmer], "confirmer not unique");

            isConfirmer[confirmer] = true;
            confirmers.push(confirmer);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
        MintMaxSize = mintMaxSize_;
    }

    modifier callerIsUser() {
        if (tx.origin != msg.sender) {
            revert CallerIsContract();
        }
        _;
    }

    modifier onlyConfirmer() {
        require(isConfirmer[msg.sender], "not confirmer");
        _;
    }

    modifier withDrawExists(uint _index) {
        require(_index < withDrawList.length, "withDraw does not exist");
        _;
    }

    modifier notExecuted(uint _index) {
        require(!withDrawList[_index].executed, "withDraw already executed");
        _;
    }

    modifier notConfirmed(uint _index) {
        require(!withDrawConfirmRecord[_index][msg.sender], "withDraw already confirmed");
        _;
    }

    function whiteListMint(uint256 quantity, bytes32[] memory proof) public callerIsUser {
        if (!IsMinting) {
            revert MintStop();
        }

        WhiteListType whiteType = getWhiteListType(proof, keccak256(abi.encodePacked(msg.sender)));
        if (whiteType == WhiteListType.NONE) {
            revert NotInWhiteList();
        }

        uint256 mintMaxCount = NormalWhiteListMintMaxCount;
        if (whiteType == WhiteListType.DEV) {
            mintMaxCount = DevWhiteListMintMaxCount;
        }

        if (totalSupply() + quantity > MintMaxSize) {
            revert ReachMaxSupply();
        }

        if (numberMinted(msg.sender) + quantity > mintMaxCount) {
            revert MintMoreThanAllowed();
        }

        _numberMinted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function publicMint(uint256 quantity) external payable callerIsUser {
        if (!IsMinting) {
            revert MintStop();
        }

        if (!isPublicMintOn()) {
            revert PublicMintIsNotBegin();
        }

        if (totalSupply() + quantity > MintMaxSize) {
            revert ReachMaxSupply();
        }

        if (msg.value < MINT_PRICE * quantity) {
            revert NeedSendMoreETH();
        }

        _numberMinted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function ownerMint(uint256 quantity) external onlyOwner {
        if (totalSupply() + quantity > MintMaxSize) {
            revert ReachMaxSupply();
        }
        _safeMint(msg.sender, quantity);
    }

    function isPublicMintOn() public view returns (bool) {
        return block.timestamp >= publicMintStartTime;
    }

    function numberMinted(address minter) public view returns (uint256) {
        return _numberMinted[minter];
    }

    function setPublicMintStartTime(uint256 startTime) external onlyOwner {
        publicMintStartTime = startTime;
    }

    function setMerkleTreeRoot(bytes32 _devRoot, bytes32 _normalRoot) external onlyOwner {
        devWhiteListRoot = _devRoot;
        normalWhiteListRoot = _normalRoot;
    }

    function getWhiteListType(bytes32[] memory proof, bytes32 leaf)
        private
        view
        returns (WhiteListType)
    {
        if ( MerkleProof.verify(proof, devWhiteListRoot, leaf) ) {
            return WhiteListType.DEV;
        }

        if ( MerkleProof.verify(proof, normalWhiteListRoot, leaf) ) {
            return WhiteListType.NORMAL;
        }

        return WhiteListType.NONE;
    }

    function setMintState(bool state) external onlyOwner {
        IsMinting = state;
    }

//    function withdrawMoney() external onlyOwner {
//        uint256 curBalance = address(this).balance;
//        require(curBalance > 0, "No ether left to withdraw");
//        (bool success, ) = msg.sender.call{value: curBalance}("");
//        require(success, "Transfer failed");
//    }

    /*
        withdraw function start
    */
    function submitWithDraw(address _to, uint256 _value, bytes memory _data) public onlyConfirmer {
        uint index = withDrawList.length;

        withDrawList.push(
            WithDrawInfo({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitWithDraw(msg.sender, index, _to, _value, _data);
    }

    function confirmWithDraw(uint _index)
        public
        onlyConfirmer
        withDrawExists(_index)
        notExecuted(_index)
        notConfirmed(_index)
    {
        WithDrawInfo storage withDraw = withDrawList[_index];
        withDraw.numConfirmations += 1;
        withDrawConfirmRecord[_index][msg.sender] = true;

        emit ConfirmWithDraw(msg.sender, _index);
    }

    function executeWithDraw(uint _index)
        public
        onlyConfirmer
        withDrawExists(_index)
        notExecuted(_index)
    {
        uint256 curBalance = address(this).balance;
        require(curBalance > 0, "No ether left to withdraw");

        WithDrawInfo storage withDraw = withDrawList[_index];

        require(
            withDraw.numConfirmations >= numConfirmationsRequired,
            "cannot execute withDraw"
        );

        require(curBalance >= withDraw.value, "curBalance less then request");

        withDraw.executed = true;

        (bool success, ) = withDraw.to.call{value: withDraw.value}(
            withDraw.data
        );
        require(success, "withDraw failed");

        emit ExecuteWithDraw(msg.sender, _index);
    }

    function revokeConfirmation(uint _index)
        public
        onlyConfirmer
        withDrawExists(_index)
        notExecuted(_index)
    {
        WithDrawInfo storage withDraw = withDrawList[_index];

        require(withDrawConfirmRecord[_index][msg.sender], "withDraw not confirmed");

        withDraw.numConfirmations -= 1;
        withDrawConfirmRecord[_index][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _index);
    }

    function getWithDrawListCount() public view returns (uint) {
        return withDrawList.length;
    }

    function getWithDrawInfo(uint _index)
        public
        view
        returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numConfirmations
        )
    {
        WithDrawInfo storage withDraw = withDrawList[_index];

        return (
        withDraw.to,
        withDraw.value,
        withDraw.data,
        withDraw.executed,
        withDraw.numConfirmations
        );
    }

    //---------------------------------------------------------------------------

    // 用于显示在OpenSea NFT首页的信息，例如：https://opensea.io/collection/azuki
    function contractURI() public pure returns (string memory) {
        return
        "https://NaughtyMouse.json";
    }

    // 用于返回NFT的元数据信息
    function getTokenURI(uint256 index) private pure returns (string memory) {
        uint256 randomIndex = index;
        string memory randomIndexString = Strings.toString(randomIndex);
        string
        memory headerString = "https://xxx";
        string memory footerString = ".json";
        string memory tokenURI = string.concat(
            headerString,
            randomIndexString,
            footerString
        );
        return tokenURI;
    }
}