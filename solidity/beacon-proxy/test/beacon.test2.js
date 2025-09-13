
const { ethers, upgrades } = require("hardhat");

describe("Beacon Test", function () {

  it("Should deploy and upgrade contracts", async function () {
    // 部署实现合约
    const HImplemention = await ethers.getContractFactory("HImplemention");
    const HImplementionContract = await HImplemention.deploy();
    await HImplementionContract.waitForDeployment();
    const HImplementionAddress = await HImplementionContract.getAddress();
    console.log("实现合约地址:", HImplementionAddress)

    // 部署信标合约并设置构造参数
    const HBeacon = await ethers.getContractFactory("HBeacon");
    const HBeaconContract = await HBeacon.deploy(HImplementionAddress);
    await HBeaconContract.waitForDeployment();
    const HBeaconAddress = await HBeaconContract.getAddress();
    console.log("信标合约地址:", HBeaconAddress)

    // 部署工厂合约
    const HFactory = await ethers.getContractFactory("HBeaconFactory");
    const HFactoryContract = await upgrades.deployProxy(HFactory, [HBeaconAddress], {
      initializer: "initialize",
      kind: "uups",
    });
    await HFactoryContract.waitForDeployment();
    const HFactoryAddress = await HFactoryContract.getAddress();
    console.log("工厂合约地址:", HFactoryAddress)

    // 创建信标代理
    const proxyContract = await ethers.getContractAt("HBeaconFactory", HFactoryAddress);
    await proxyContract.createBeaconProxy();

    // 获取代理合约地址
    const beaconProxyAddress = await proxyContract.getBeaconProxys();
    console.log("代理合约地址:", beaconProxyAddress)

    // 使用实现合约的ABI连接到代理合约
    const beaconProxy = await ethers.getContractAt("HImplemention", beaconProxyAddress[0]);

    // 现在可以调用setNum函数
    await beaconProxy.setNum(23);

    // 验证
    const num = await beaconProxy.getNum();
    console.log("设置后的数字:", num);

  })
})