const { ethers } = require("hardhat");


describe("NFTAuctionFactory", async function () {
  it("Should deploy NFTAuctionFactory", async function () {

    // 部署NFT合约
    const NFT = await ethers.getContractFactory("NFT");
    const NFTContract = await NFT.deploy();
    await NFTContract.waitForDeployment();

    const NFTAddress = await NFTContract.getAddress();
    console.log("======NFT合约地址=====", NFTAddress);

    // 初始化
    await NFTContract.initialize("NFT", "MNFT");
    // 给发送者铸造
    const [deployer] = await ethers.getSigners();
    await NFTContract.mintNFT(deployer.address, "https://olive-genetic-whale-994.mypinata.cloud/ipfs/bafkreiehkktvfv3eo2dqds4bjtj6ti5f5wyxalbjvz2ca5dfnwuequjvyq");
    // 确认NFT的所有权
    const owner = await NFTContract.ownerOf(1);
    console.log("NFT所有者:", owner);

    // 给发送者铸造
    await NFTContract.mintNFT(deployer.address, "https://olive-genetic-whale-994.mypinata.cloud/ipfs/bafkreiehkktvfv3eo2dqds4bjtj6ti5f5wyxalbjvz2ca5dfnwuequjvyq");
    // 确认NFT的所有权
    const owner2 = await NFTContract.ownerOf(2);
    console.log("NFT所有者:", owner2);

    // 部署NFTAuction合约
    const NFTAuction = await ethers.getContractFactory("NFTAuction");
    const auction = await NFTAuction.deploy();
    await auction.waitForDeployment();

    const auctionAddress = await auction.getAddress();
    console.log("======NFTAuction合约地址=====", auctionAddress);

    // 部署NFTAuctionFactory合约
    const NFTAuctionFactory = await ethers.getContractFactory("NFTAuctionFactory");
    const factory = await NFTAuctionFactory.deploy();
    await factory.waitForDeployment();

    const factoryAddress = await factory.getAddress();
    console.log("======NFTAuctionFactory合约地址=====", factoryAddress);

    // 初始化
    await factory.initialize(auctionAddress);

    // 创建拍卖合约
    await factory.createAuction();

    // 查询拍卖合约实例列表
    const auctions = await factory.getAuctions();
    console.log("======拍卖合约实例列表=====", auctions);

    // 授权当前合约地址
    console.log("======授权当前合约地址=====", auctions[0]);
    await NFTContract.approve(auctions[0], 1);

    const currentTimestamp = Math.floor(Date.now() / 1000);
    // 减去100秒
    const startTime = currentTimestamp - 100;

    console.log("======创建拍卖=====");
    // 调用createAuction函数
    const auctionInstance = await ethers.getContractAt("NFTAuction", auctions[0]);
    await auctionInstance.createAuction(
      1,
      NFTAddress,
      startTime,
      500000,
      ethers.ZeroAddress
    );
    // 查询拍卖信息
    const _auctionInfo = await auctionInstance.getAuctionItem(1);
    console.log("======查询拍卖信息=====", _auctionInfo)

    // 部署NFTAuctionV2合约
    const NFTAuctionV2 = await ethers.getContractFactory("NFTAuctionV2");
    const auctionV2 = await NFTAuctionV2.deploy();
    await auctionV2.waitForDeployment();

    const auctionV2Address = await auctionV2.getAddress();
    console.log("======NFTAuctionV2合约地址=====", auctionV2Address);

    // NFTAuction合约升级为NFTAuctionV2
    await auctionInstance.upgradeTo(auctionV2Address);

    // 调用NFTAuction合约的函数查询原数据
    const auctionV2Instance = await ethers.getContractAt("NFTAuctionV2", auctions[0]);
    // 创建拍卖
    await NFTContract.approve(auctions[0], 2);
    await auctionV2Instance.createAuction(
      2,
      NFTAddress,
      startTime,
      300000,
      ethers.ZeroAddress
    );

    const _auctionInfo1 = await auctionInstance.getAuctionItem(1);
    console.log("======查询拍卖信息1=====", _auctionInfo1)

    const _auctionInfo2 = await auctionInstance.getAuctionItem(2);
    console.log("======查询拍卖信息2=====", _auctionInfo2)

    // 调用NFTAuctionV2合约的函数
    const _test = await auctionV2Instance.test();
    console.log("======查询拍卖信息=====", _test)



  });
});