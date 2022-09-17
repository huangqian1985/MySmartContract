// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DoMetaNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address owner;

    uint MintMaxTotal = 666;
    uint MintMaxCount = 5;
    uint MintMinCount = 1;

    // 默克尔树root
    bytes32 public root = 0x9508de33d89ea988d78c623e14f7b0f8ec6cd2900ea5bfcb876ceb4860fb4b21;

    bool IsMinting = true;

    constructor() ERC721("DoMeta NFT", "DoMeta") {
        owner = msg.sender;
        _tokenIds.increment();  // tokenId 从1开始，减少gas费
    }

    function mint(address player) private returns (uint256) {
        require(IsMinting, "Mint is Stop!");
        uint256 newItemId = _tokenIds.current();
        string memory tokenURI = getTokenURI(newItemId);
        require(MintMaxTotal >= newItemId, "Mint MaxCount overflow!");
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenIds.increment();
        return newItemId;
    }

    // 合约拥有者mint，没有数量限制
    function mintByOwner(uint times) external byOwner {
        for (uint key = 0; key < times; key++) {
            mint(owner);
        }
    }

    // 白名单mint
    function mintWhiteLists(address player, bytes32[] memory proof) external {
        require(isWhiteLists(proof, keccak256(abi.encodePacked(player))));
        mint(player);
    }

    // 设置最大mint数量
    function setMintTotal(uint count) external byOwner {
        MintMaxTotal = count;
    }

    // 设置mint状态
    function checkoutMintState(bool state) external byOwner {
        IsMinting = state;
    }

    // 设置默克尔树root(白名单变化时重新设置)
    function setMerkleTreeRoot(bytes32 _root) external byOwner {
        root = _root;
    }

    // 白名单判断
    function isWhiteLists(bytes32[] memory proof, bytes32 leaf)
        private
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
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

    // 合约拥有者修饰
    modifier byOwner() {
        require(msg.sender == owner, "Must be owner!");
        _;
    }
}