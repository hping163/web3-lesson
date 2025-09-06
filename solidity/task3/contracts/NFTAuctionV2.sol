// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import './NFTAuction.sol';

// 升级后的合约
contract NFTAuctionV2 is NFTAuction {
    function test() public pure returns (string memory) {
        return 'hello world';
    }
}
