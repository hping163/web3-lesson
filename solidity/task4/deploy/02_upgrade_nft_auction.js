const { ethers } = require("hardhat")

const fs = require("fs")
const path = require("path")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { save } = deployments;
  const { deployer } = await getNamedAccounts();

  // 读取.cache/auction.json文件
  const savePath = path.resolve(__dirname, "./.cache/auction.json")
  const { proxyAddress, implementAddress, abi } = JSON.parse(fs.readFileSync(savePath, "utf8"))

  console.log("auction.json内容：", {
    proxyAddress,
    implementAddress,
    abi,
  })

  // 升级后的合约
  const auctionV2 = await ethers.getContractFactory("AuctionV2")
  // 升级合约
  const auctionV2Proxy = await upgrades.upgradeProxy(proxyAddress, auctionV2)
  await auctionV2Proxy.waitForDeployment()

  const auctionV2ProxyAddress = await auctionV2Proxy.getAddress()
  console.log("升级后的合约地址", auctionV2ProxyAddress)

  save("AuctionV2Proxy", {
    address: auctionV2ProxyAddress,
    abi: auctionV2.interface.format("json"),
  })
}

module.exports.tags = ["upgradeAuction"]
