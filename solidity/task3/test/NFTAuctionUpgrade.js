const { ethers, deployments } = require("hardhat")


describe("NFTAuctionUpgrade", async function () {
  it("should upgrade NFTAuctionV2", async function () {
    // 部署合约
    deployments.fixture(["deployNFTAuction"]);

    // 获取代理合约
    const nftAuctionProxy = deployments.get("NFTAuctionProxy")
    console.log("======代理合约地址=====", nftAuctionProxy.address);

    // 获取NFT合约
    const nft = await ethers.getContractFactory("NFT");
    const nftContract = await nft.deploy();
    await nftContract.waitForDeployment();

    const nftAddress = await nftContract.getAddress();
    console.log("======NFT合约地址=====", nftAddress);

    // 创建拍卖
    const nftAuction = await ethers.getContractAt("NFTAuction", nftAuctionProxy.address);
    await nftAuction.createAuction(
      1,
      nftAddress,
      startTime,
      500000,
      ethers.ZeroAddress
    );

    // 升级合约


    // 调用升级后的合约
  })
})