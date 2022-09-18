// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721psi/contracts/ERC721Psi.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

    error CallerIsContract();

/**
 @author DoMeta Labs
 @title DoMeta NFT
 */
contract DoMetaNFT is ERC721Psi, Ownable {

    uint256 public immutable MintMaxTotal;

    mapping(address => uint256) public _numberMinted;

    uint256 public publicMintStartTime = 0xFFFFFFFF;

    uint256 public constant MINT_PRICE = 0.001 ether;

    uint256 public constant MintMaxCount = 5;

    // 默克尔树root
    bytes32 public whiteListRoot = 0x0;

    bool public IsMinting = true;

    constructor(uint256 mintMaxSize_) ERC721Psi("DoMeta NFT", "DoMeta") {
        MintMaxTotal = mintMaxSize_;
    }

    modifier callerIsUser() {
        if (tx.origin != msg.sender) {
            revert CallerIsContract();
        }
        _;
    }

    function ownerMint(uint256 quantity) external onlyOwner {
        require (totalSupply() + quantity <= MintMaxTotal, "ReachMaxSupply");
        _numberMinted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function whiteListMint(uint256 quantity, bytes32[] memory proof) public callerIsUser {
        require (IsMinting, "Mint is Stop");
        require (totalSupply() + quantity <= MintMaxTotal, "Reach MaxSupply");
        require (isWhiteList(proof, keccak256(abi.encodePacked(msg.sender))), "Not In WhiteList");
        require (numberMinted(msg.sender) + quantity <= MintMaxCount, "Mint More Than Allowed");

        _numberMinted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function publicMint(uint256 quantity) external payable callerIsUser {
        require (IsMinting, "Mint is Stop");
        require (isPublicMintOn(), "PublicMint Is Not Begin");
        require (totalSupply() + quantity <= MintMaxTotal, "Reach MaxSupply");
        require (msg.value >= MINT_PRICE * quantity, "Need Send More ETH");
        require (numberMinted(msg.sender) + quantity <= MintMaxCount, "Mint More Than Allowed");

        _numberMinted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function isPublicMintOn() public view returns (bool) {
        return block.timestamp >= publicMintStartTime;
    }

    function isWhiteList(bytes32[] memory proof, bytes32 leaf)
        private
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, whiteListRoot, leaf);
    }

    function numberMinted(address minter) public view returns (uint256) {
        return _numberMinted[minter];
    }

    function setPublicMintStartTime(uint256 startTime) external onlyOwner {
        publicMintStartTime = startTime;
    }

    function setMerkleTreeRoot(bytes32 _root) external onlyOwner {
        whiteListRoot = _root;
    }

    function setMintState(bool state) external onlyOwner {
        IsMinting = state;
    }

    // 用于显示在OpenSea NFT首页的信息，例如：https://opensea.io/collection/azuki
    function contractURI() public pure returns (string memory) {
        return
            "https://dometa_nft.json";
    }

    // 用于返回NFT的元数据信息
    function getTokenURI(uint256 index) private pure returns (string memory) {
        string memory indexString = Strings.toString(index);
        string
            memory headerString = "https://xxx/";
        string memory footerString = ".json";
        string memory tokenURI = string.concat(
            headerString,
            indexString,
            footerString
        );
        return tokenURI;
    }
}