// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Auction is Initializable, UUPSUpgradeable {
    // 结构体
    struct Bid {
        uint256 bidId;
        address seller;
        address nftAddress;
        uint256 tokenId;
        uint256 startTime;
        uint256 duration;
        uint256 startPrice;
        address highestBidder;
        uint256 highestBid;
        bool isEnded;
        uint256 endTime;
    }

    // 管理员
    address private admin;

    // 初始化
    function initialize() public initializer {
        admin = msg.sender;
    }

    // 出价列表 出价ID => 出价
    mapping(uint256 => Bid) public bids;

    // 下一个出价ID
    uint256 private _nextBidId;

    // 创建
    function createAuction(
        address nftAddress,
        uint256 tokenId,
        uint256 startTime,
        uint256 duration,
        uint256 startPrice
    ) external {
        Bid memory _bid = Bid({
            bidId: _nextBidId,
            seller: msg.sender,
            nftAddress: nftAddress,
            tokenId: tokenId,
            startTime: startTime,
            duration: duration,
            startPrice: startPrice,
            highestBidder: address(0),
            highestBid: 0,
            isEnded: false,
            endTime: 0
        });
        // 增加出价
        bids[_nextBidId] = _bid;

        // 增加出价ID
        _nextBidId++;
    }

    // 出价
    function bidprice(
        uint256 bidId,
        uint256 amount
    ) external payable returns (bool) {
        Bid storage bid = bids[bidId];
        require(bid.isEnded == false, "Auction is ended");
        require(amount > bid.highestBid, "Amount is less than highest bid");
        require(amount > bid.startPrice, "Amount is less than start price");

        bid.highestBidder = msg.sender;
        bid.highestBid = amount;

        return true;
    }

    // 重写父类方法
    function _authorizeUpgrade(address) internal override view {
        require(msg.sender == admin, "Not admin");
    }
}
