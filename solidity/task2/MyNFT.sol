// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721, ERC721URIStorage {
    uint256 private _totalSupply;

    constructor() ERC721("MyNFT", "MNFT") {}

    // 铸币函数
    function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
        _totalSupply++;
        uint256 newItemId = _totalSupply;
        super._mint(recipient, newItemId);
        super._setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    // 查询总供应量
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // 重写父合约的tokenURI函数
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // 重写父合约的tokenURI函数
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);  
    }
}
