// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import './NFTAuction.sol';

contract NFTAuctionFactory is OwnableUpgradeable, UUPSUpgradeable {
    // 拍卖合约实例列表
    address[] private auctions;
    // 实现合约地址
    address private implAddress;

    // 初始化
    function initialize(address _implementation) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();

        implAddress = _implementation;
    }

    // 创建合约的事件
    event AuctionCreated(address owner, address auctionAddress);

    // 创建拍卖合约
    function createAuction() public payable returns (address) {
        bytes memory _data = abi.encodeWithSelector(NFTAuction.initialize.selector);
        ERC1967Proxy auctionProxy = new ERC1967Proxy(implAddress, _data);
        auctions.push(address(auctionProxy));
        emit AuctionCreated(msg.sender, address(auctionProxy));
        return address(auctionProxy);
    }

    // 获取拍卖合约实例列表
    function getAuctions() public view returns (address[] memory) {
        return auctions;
    }

    // 获取合约总量
    function getAuctionCount() public view returns (uint256) {
        return auctions.length;
    }

    // 升级实现合约
    function _authorizeUpgrade(address) internal view override onlyOwner {}
}
