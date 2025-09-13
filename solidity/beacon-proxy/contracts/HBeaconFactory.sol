// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import './HImplemention.sol';

contract HBeaconFactory is OwnableUpgradeable, UUPSUpgradeable {
    // 信标合约
    address public beacon;
    // 代理合约实例
    address[] public beaconProxys;

    // 初始化
    function initialize(address _beacon) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();

        beacon = _beacon;
    }

    // 授权升级
    function _authorizeUpgrade(address) internal view override onlyOwner {}

    // 创建代理合约
    function createBeaconProxy() external returns (address) {
        bytes memory data = abi.encodeWithSelector(HImplemention.initialize.selector);
        BeaconProxy _beaconProxy = new BeaconProxy(beacon, data);
        address _beaconProxyAddress = address(_beaconProxy);
        return _beaconProxyAddress;
    }

    function getBeaconProxys() external view returns (address[] memory) {
        return beaconProxys;
    }
}
