// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import './NFTAuction.sol';

contract NFTAuctionFactory {
    // 拍卖合约实例列表
    address[] private auctions;

    // 创建合约的事件
    event AuctionCreated(address auctionAddress, address nftAddress, uint256 tokenId, uint256 timestamp);

    // 创建拍卖合约
    function createAuction(address nftAddress, uint256 tokenId) public returns (address) {
        NFTAuction auction = new NFTAuction();
        auction.initialize();
        auctions.push(address(auction));
        emit AuctionCreated(address(auction), nftAddress, tokenId, block.timestamp);
        return address(auction);
    }

    // 获取拍卖合约实例列表
    function getAuctions() public view returns (address[] memory) {
        return auctions;
    }

    // 获取合约总量
    function getAuctionCount() public view returns (uint256) {
        return auctions.length;
    }
}
