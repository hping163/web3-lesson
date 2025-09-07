// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 实现合约
contract HImplementionV2 {
    uint256 public num;
    function setNum(uint256 _num) public {
        num = _num;
    }
    function getNum() public view returns (uint256) {
        return num;
    }

    function getVersion() public pure returns (string memory) {
        return '2.0';
    }
}
