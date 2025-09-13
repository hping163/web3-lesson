// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import { AggregatorV3Interface } from '@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';
import 'hardhat/console.sol';

// 拍卖合约
contract NFTAuction is OwnableUpgradeable, UUPSUpgradeable {
    error AddressInvalid(address nftAddress, uint256 tokenId);
    // 拍卖结束事件
    event AuctionEnded(uint256 tokenId, address winner, uint256 amount);
    // 出价事件
    event BidPlaced(uint256 tokenId, address bidder, uint256 amount, uint256 bidValueInUSD);

    // 拍卖商品结构体
    struct AuctionItem {
        uint256 tokenId; // 拍卖商品的tokenId
        address nftAddress; // 拍卖商品的合约地址
        address seller; // 拍卖商品的卖家
        uint256 startTime; // 拍卖开始时间
        uint256 duration; // 拍卖持续时间
        address highestBidder; // 最高出价者
        uint256 highestBid; // 最高出价
        address tokenAddress; // 拍卖商品的代币地址
        bool ended; // 拍卖是否结束
        uint256 endTime; // 拍卖结束时间
    }
    // 拍卖商品列表 商品ID => 拍卖商品
    mapping(uint256 => AuctionItem) private auctions;

    // 管理员
    address private admin;

    // 初始化
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    // 创建拍卖
    function createAuction(uint256 tokenId, address nftAddress, uint256 startTime, uint256 duration, address tokenAddess) external returns (bool) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) == msg.sender, 'Not owner');
        uint256 endTime = startTime + duration;
        require(startTime < block.timestamp && endTime > block.timestamp, 'Invalid time');

        console.log('nftAddress::', nftAddress, '\ntokenId::', tokenId);

        // 授权 (这里授权为什么会无效，而在测试用例中写就可以呢？？？)
        // IERC721Upgradeable(nftAddress).approve(address(this), tokenId);

        // 转移NFT到合约
        IERC721Upgradeable(nftAddress).transferFrom(msg.sender, address(this), tokenId);

        AuctionItem memory auctionItem = AuctionItem({ tokenId: tokenId, nftAddress: nftAddress, seller: msg.sender, startTime: startTime, duration: duration, highestBidder: address(0), highestBid: 0, tokenAddress: tokenAddess, ended: false, endTime: 0 });
        auctions[tokenId] = auctionItem;

        return true;
    }

    // 查询拍卖商品
    function getAuctionItem(uint256 tokenId) external view returns (AuctionItem memory) {
        return auctions[tokenId];
    }

    // 出价结构体
    struct Bid {
        uint256 tokenId; // 商品ID
        address bidder; // 出价者
        uint256 amount; // 出价金额
        address tokenAddress; // 出价代币地址
        uint256 timestamp; // 出价时间
        uint256 bidValueInUSD; // 出价金额的美元价值
    }
    // 商品出价列表 商品Id => 出价列表
    mapping(uint256 => Bid[]) private bids;

    // 出价
    function priceBid(uint256 tokenId, uint256 amount) external payable returns (bool) {
        AuctionItem memory _auctionItem = auctions[tokenId];
        require(_auctionItem.startTime + _auctionItem.duration > block.timestamp, 'Auction end');
        require(amount > _auctionItem.highestBid, 'Bid too low');

        // 计算出价金额的美元价值
        uint256 bidValueInUSD;

        // 允许用户以 ERC20 或以太坊出价
        if (_auctionItem.tokenAddress == address(0)) {
            console.log('======EHT bid=====', amount);
            payable(address(this)).transfer(amount);
            // bidValueInUSD = getPriceFeed(address(0)) * amount;
        } else {
            // ERC20 代币出价
            IERC20Upgradeable(_auctionItem.tokenAddress).transferFrom(msg.sender, address(this), amount);
            bidValueInUSD = getPriceFeed(_auctionItem.tokenAddress) * amount;
        }

        // 如果不是首次出价，则退回上一个出价者的金额
        if (_auctionItem.highestBidder != address(0)) {
            if (_auctionItem.tokenAddress == address(0)) {
                // 以太坊
                payable(_auctionItem.highestBidder).transfer(_auctionItem.highestBid);
                console.log('======back EHT=====', _auctionItem.highestBid);
            } else {
                // ERC20
                IERC20Upgradeable(_auctionItem.tokenAddress).transfer(_auctionItem.highestBidder, _auctionItem.highestBid);
            }
        }

        // 记录出价
        Bid memory _bid = Bid({ tokenId: tokenId, bidder: msg.sender, amount: amount, tokenAddress: _auctionItem.tokenAddress, timestamp: block.timestamp, bidValueInUSD: bidValueInUSD });
        bids[tokenId].push(_bid);
        // 更新最高出价
        _auctionItem.highestBid = amount;
        _auctionItem.highestBidder = msg.sender;
        auctions[tokenId] = _auctionItem;

        // 记录出价事件
        emit BidPlaced(tokenId, msg.sender, amount, bidValueInUSD);

        return true;
    }

    // 查询出价记录
    function getBidItem(uint256 tokenId) external view returns (Bid[] memory) {
        return bids[tokenId];
    }

    // 结束拍卖
    function endAuction(uint256 tokenId) external returns (bool) {
        AuctionItem memory _auctionItem = auctions[tokenId];
        // require(IERC721Upgradeable(_auctionItem.nftAddress).ownerOf(tokenId) == address(this), 'Not owner');
        require(!_auctionItem.ended, 'Auction ended');
        require(_auctionItem.startTime + _auctionItem.duration > block.timestamp, 'Auction end');

        // 确认拍卖结果
        if (_auctionItem.highestBidder == address(0)) {
            revert AddressInvalid(_auctionItem.nftAddress, tokenId);
        }
        // 转移NFT给最高出价者
        // IERC721Upgradeable(_auctionItem.nftAddress).safeTransferFrom(address(this), _auctionItem.highestBidder, tokenId);
        // 转移代币给卖家
        if (_auctionItem.tokenAddress == address(0)) {
            // 以太坊
            payable(_auctionItem.seller).transfer(_auctionItem.highestBid);
        } else {
            // ERC20
            IERC20Upgradeable(_auctionItem.tokenAddress).transfer(_auctionItem.seller, _auctionItem.highestBid);
        }
        // 更新拍卖状态
        _auctionItem.ended = true;
        _auctionItem.endTime = block.timestamp;
        auctions[tokenId] = _auctionItem;

        emit AuctionEnded(tokenId, _auctionItem.highestBidder, _auctionItem.highestBid);
        return true;
    }

    // 代币地址对美元价格的映射
    mapping(address => AggregatorV3Interface) private tokenPriceFeeds;

    // 维护代币地址对美元价格的映射
    function setTokenPriceFeed(address tokenAddress, address priceFeedAddress) external {
        require(msg.sender == admin, 'Not admin');
        tokenPriceFeeds[tokenAddress] = AggregatorV3Interface(priceFeedAddress);
    }

    // 获取代币对应的美元价格
    function getPriceFeed(address tokenAddress) internal view returns (uint256) {
        AggregatorV3Interface priceFeed = tokenPriceFeeds[tokenAddress];
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    // 授权升级
    function _authorizeUpgrade(address) internal view override onlyProxy {}

    receive() external payable {}

    fallback() external payable {}
}
