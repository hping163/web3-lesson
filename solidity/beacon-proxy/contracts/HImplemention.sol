// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

// 实现合约
contract HImplemention is UUPSUpgradeable, OwnableUpgradeable {
    uint256 public num;

    function _authorizeUpgrade(address) internal view override onlyOwner {}

    // 初始化
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function setNum(uint256 _num) public {
        num = _num;
    }
    function getNum() public view returns (uint256) {
        return num;
    }
}
