// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * 基础处理合约
 */
contract Basic {

    // 反转一个字符串。输入 "abcde"，输出 "edcba"
    function stringRone(string memory str) public pure returns(string memory) {
        bytes memory bytesStr = bytes(str);
        for (uint256 i = 0; i < bytesStr.length / 2; i++) {
            (bytesStr[i], bytesStr[bytesStr.length - 1 - i]) = (bytesStr[bytesStr.length - 1 - i], bytesStr[i]);
        }
        return string(bytesStr);
    }
    
    // 合并两个有序数组，组成一个新的有序数组
    function mergeArray(uint256[] memory arr1, uint256[] memory arr2) public pure returns(uint256[] memory) {
        uint256[] memory newArr = new uint256[](arr1.length + arr2.length);
        // 先把arr1和arr2的元素复制到newArr
        for (uint256 i = 0; i < arr1.length; i++) {
            newArr[i] = arr1[i];
        }
        for (uint256 i = 0; i < arr2.length; i++) {
            newArr[arr1.length + i] = arr2[i];
        }
        // 对newArr进行排序
        for (uint256 i = 0; i < newArr.length; i++) {
            for (uint256 j = 0; j < newArr.length - 1 - i; j++) {
                if (newArr[j] > newArr[j + 1]) {
                    (newArr[j], newArr[j + 1]) = (newArr[j + 1], newArr[j]);
                }
            }
        }
        return newArr;
    }

    // 二分查找
    function binarySearch(uint256[] memory arr, uint256 target) public pure returns(uint256) {
        uint256 left = 0;
        uint256 right = arr.length - 1;
        while (left <= right) {
            uint256 mid = (left + right) / 2;
            if (arr[mid] == target) {
                return mid;
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return 0;
    }


}