const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Beacon Proxy Test", async function () {
  it("Should deploy and upgrade contracts", async function () {

    // 部署实现合约
    const HImplemention = await ethers.getContractFactory("HImplemention");
    // 部署信标合约
    const HBeacon = await upgrades.deployBeacon(HImplemention);
    await HBeacon.waitForDeployment();

    // 部署代理合约
    const HProxy = await upgrades.deployBeaconProxy(HBeacon, HImplemention, []);
    await HProxy.waitForDeployment();

    // 通过代理合约调用实现合约的函数
    const HProxyContract = await ethers.getContractAt("HImplemention", HProxy.target);
    await HProxyContract.setNum(100);
    // 查询实现合约的number
    const number = await HProxyContract.getNum();
    expect(number).to.equal(100);
    console.log("升级前的num:", number)

    // 升级实现合约
    const HImplementionV2 = await ethers.getContractFactory("HImplementionV2");
    await upgrades.upgradeBeacon(HBeacon, HImplementionV2);

    // 升级后通过代理合约调用实现合约的函数
    const HProxyContractV2 = await ethers.getContractAt("HImplementionV2", HProxy.target);

    // 升级后查询num
    const num = await HProxyContractV2.getNum();
    console.log("升级后查询num:", num);
    expect(number).to.equal(num);

    // 升级后查询version
    const version = await HProxyContractV2.getVersion();
    console.log("升级后查询version:", version);
    expect(version).to.equal('2.0');
  });
});