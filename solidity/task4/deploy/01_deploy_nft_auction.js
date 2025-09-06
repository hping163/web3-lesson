const { deployments, upgrades, ethers } = require("hardhat")
const fs = require("fs")
const path = require("path")

/*
 * ardhat-deploy插件通过集成OpenZeppelin的升级插件（@openzeppelin/hardhat-upgrades）来自动处理代理合约的部署。其核心逻辑如下：
 * 代理模式：使用OpenZeppelin的透明代理模式（Transparent Proxy），代理合约将调用委托给逻辑合约，同时保留升级能力。
 * 自动生成：当调用deployProxy时，插件会自动：
 * 编译并部署逻辑合约（你的业务合约）
 * 生成并部署代理合约（无需手动编写）
 * 建立代理-逻辑合约的关联
 * 升级机制：代理合约固定不变，后续升级只需部署新的逻辑合约并通过upgradeProxy更新指向。
 * 安全性：内置的升级检查会验证：
 * 存储布局兼容性
 * 初始化函数保护
 * 管理员权限控制
 * 这种设计让你可以专注于业务逻辑，而无需手动处理代理合约的复杂性
 */

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { save } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("用户部署的地址", deployer)

  // 部署实现合约
  const auctionContract = await ethers.getContractFactory("Auction")

  // 部署代理合约
  const auctionProxy = await upgrades.deployProxy(auctionContract, {
    initializer: "initialize",
  })
  auctionProxy.waitForDeployment(); // 等待部署成功

  const proxyAddress = await auctionProxy.getAddress()
  console.log("代理合约地址", proxyAddress)

  const implementAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress)
  console.log("实现合约地址", implementAddress)

  const savePath = path.resolve(__dirname, "./.cache/auction.json")
  fs.writeFileSync(savePath, JSON.stringify({
    proxyAddress,
    implementAddress,
    abi: auctionContract.interface.format("json"),
  }))

  await save("AuctionProxy", {
    address: proxyAddress,
    abi: auctionContract.interface.format("json"),
  })
}

module.exports.tags = ["deployAuction"];
