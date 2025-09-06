const { ethers, upgrades } = require("hardhat");
const fs = require("fs")
const path = require("path")


module.exports = async function ({ deployments }) {
  const { save } = deployments;
  const [deployer] = await ethers.getSigners();

  // 从缓存文件获取代理地址
  const storePath = path.resolve(__dirname, "./.cache/cache_nft_auction.json")
  const { proxyAddress, implementAddress, abi } = JSON.parse(fs.readFileSync(storePath))

  // 升级后的合约
  const NFTAuctionV2 = await ethers.getContractFactory("NFTAuctionV2");
  const nftAuctionV2Proxy = await upgrades.upgradeProxy(proxyAddress, NFTAuctionV2);
  await nftAuctionV2Proxy.waitForDeployment();

  // 升级后的代理合约地址
  const nftAuctionV2ProxyAddress = await nftAuctionV2Proxy.getAddress()
  console.log("NFTAuctionV2 upgraded to proxyAddress:", nftAuctionV2ProxyAddress);

  // 升级后的实现合约地址
  const nftAuctionV2ImplementAddress = await upgrades.erc1967.getImplementationAddress(nftAuctionV2ProxyAddress)
  console.log("NFTAuctionV2 upgraded to implementAddress:", nftAuctionV2ImplementAddress);

  // 保存升级后的合约地址
  save("NFTAuctionV2Proxy", {
    address: nftAuctionV2ProxyAddress,
    abi: NFTAuctionV2.interface.format("json"),
  })
}

module.exports.tags = ["upgradeNFTAuction"]
