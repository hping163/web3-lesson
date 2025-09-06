const { ethers, upgrades } = require("hardhat");
const fs = require("fs")
const path = require("path")

module.exports = async function ({ deployments }) {
  const { save } = deployments;
  const [deployer] = await ethers.getSigners();

  // 实现合约
  const nftAuction = await ethers.getContractFactory("NFTAuction");
  // 代理合约
  const nftAuctionProxy = await upgrades.deployProxy(nftAuction, {
    initializer: "initialize",
  });
  await nftAuctionProxy.waitForDeployment();

  const nftAuctionProxyAddress = await nftAuctionProxy.getAddress()

  console.log("Proxy Contract Address:", nftAuctionProxyAddress);
  console.log("Implementation Contract Address:", await upgrades.erc1967.getImplementationAddress(nftAuctionProxyAddress));

  // 写到缓存文件里
  fs.writeFileSync(
    path.resolve(__dirname, "./.cache/cache_nft_auction.json"),
    JSON.stringify({
      proxyAddress: nftAuctionProxyAddress,
      implementAddress: await upgrades.erc1967.getImplementationAddress(nftAuctionProxyAddress),
      abi: nftAuction.interface.format("json"),
    })
  )

  // 导出合约
  save("NFTAuctionProxy", {
    address: nftAuctionProxyAddress,
    abi: nftAuction.interface.format("json"),
  })
};

module.exports.tags = ["deployNFTAuction"];