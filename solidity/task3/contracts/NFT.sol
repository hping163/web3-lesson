// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import 'hardhat/console.sol';

/**
 * @title MyNFT
 * @notice 增强版ERC721 NFT合约，支持元数据存储和批量铸造
 */
contract NFT is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable, IERC721ReceiverUpgradeable {
    uint256 private nextTokenId;

    // 元数据更新事件
    event TokenURIUpdated(uint256 indexed tokenId, string uri);

    // 初始化函数
    function initialize(string memory name, string memory symbol) public initializer {
        __ERC721_init(name, symbol);
        __Ownable_init();
    }

    // 铸造单个NFT
    function mintNFT(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = ++nextTokenId;
        console.log('======tokenId=====', tokenId);
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    /**
     * @notice 批量铸造NFT
     * @param to 接收地址数组
     * @param uris 元数据URI数组
     */
    function batchMint(address[] memory to, string[] memory uris) public onlyOwner {
        require(to.length == uris.length, 'Arrays length mismatch');
        for (uint256 i = 0; i < to.length; i++) {
            mintNFT(to[i], uris[i]);
        }
    }

    // 更新tokenURI
    function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
        require(tokenId > 0, 'Token does not exist');
        _setTokenURI(tokenId, uri);
        emit TokenURIUpdated(tokenId, uri);
    }

    // 重写函数以支持ERC721URIStorage
    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // 重写函数以支持ERC721URIStorage
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // 重写函数以支持ERC721URIStorage
    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    /**
     * @dev 实现IERC721Receiver接口
     * @return 返回函数选择器
     */
    function onERC721Received(address, address, uint256, bytes memory) public pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
