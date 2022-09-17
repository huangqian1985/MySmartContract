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

/**
 @author DAO Labs
 @title NaughtyMouse NFT
 */
contract NaughtyMouseNFT is ERC721Psi, Ownable {
    mapping(address => uint256) public _numberMinted;

    uint256 public publicMintStartTime = 0xFFFFFFFF;

    uint256 public constant MINT_PRICE = 0.001 ether;

    uint256 public constant DevWhiteListMintMaxCount = 10;
    uint256 public constant NormalWhiteListMintMaxCount = 1;

    uint256 public immutable MintMaxSize;

    bool public IsMinting = true;

    bytes32 public devWhiteListRoot = 0x0;
    bytes32 public normalWhiteListRoot = 0x0;

    enum WhiteListType {
        NONE,
        DEV,
        NORMAL
    }

    constructor(uint256 mintMaxSize_) ERC721Psi("NaughtyMouse NFT", "NaughtyMouse") {
        MintMaxSize = mintMaxSize_;
    }

    modifier callerIsUser() {
        if (tx.origin != msg.sender) {
            revert CallerIsContract();
        }
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

    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    //---------------------------------------------------------------------------

    // 用于显示在OpenSea NFT首页的信息，例如：https://opensea.io/collection/azuki
    function contractURI() public pure returns (string memory) {
        return
        "https://dometa_nft.json";
    }

    // 用于返回NFT的元数据信息
    function getTokenURI(uint256 index) private pure returns (string memory) {
        uint256 randomIndex = index;
        string memory randomIndexString = Strings.toString(randomIndex);
        string
        memory headerString = "https://raw.githubusercontent.com/CheersPals/cheerspalsofficial/main/json/";
        string memory footerString = ".json";
        string memory tokenURI = string.concat(
            headerString,
            randomIndexString,
            footerString
        );
        return tokenURI;
    }
}