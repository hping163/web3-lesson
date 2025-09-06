const { ethers } = require("hardhat")

describe("NFTAuction test", async function () {
  it("Should create an auction", async function () {
    const [deployer, user1, user2] = await ethers.getSigners();
    // 查询deployer余额
    const deployerBalance = await deployer.provider.getBalance(deployer.address);
    console.log("======部署者余额=====", deployerBalance);
    // 部署NFT合约
    const NFT = await ethers.getContractFactory("NFT");
    const NFTContract = await NFT.connect(deployer).deploy();
    await NFTContract.waitForDeployment();

    const NFTAddress = await NFTContract.getAddress();
    console.log("======NFT合约地址=====", NFTAddress);

    // 初始化
    await NFTContract.initialize("NFT", "MNFT");
    // 铸造
    await NFTContract.mintNFT(deployer.address, "https://olive-genetic-whale-994.mypinata.cloud/ipfs/bafkreiehkktvfv3eo2dqds4bjtj6ti5f5wyxalbjvz2ca5dfnwuequjvyq");
    // 确认NFT的所有权
    const owner = await NFTContract.ownerOf(1);
    console.log("NFT所有者:", owner);

    // 部署拍卖合约
    const NFTAuction = await ethers.getContractFactory("NFTAuction");
    const AuctionContract = await NFTAuction.connect(deployer).deploy();
    await AuctionContract.waitForDeployment();
    const contractAddress = await AuctionContract.getAddress();

    console.log("======拍卖合约地址=====", contractAddress);
    // 初始化
    await AuctionContract.initialize();

    const currentTimestamp = Math.floor(Date.now() / 1000);
    // 减去100秒
    const startTime = currentTimestamp - 100;
    console.log("======创建拍卖时间=====", startTime);

    // 在调用createAuction前添加
    await NFTContract.approve(contractAddress, 1);
    await AuctionContract.createAuction(
      1,
      NFTAddress,
      startTime,
      500000,
      ethers.ZeroAddress
    );

    // 查询拍卖信息
    const _auctionInfo = await AuctionContract.connect(deployer).getAuctionItem(1);
    console.log("======查询拍卖信息=====", _auctionInfo)

    // 维护代币地址对美元价格的映射
    await AuctionContract.setTokenPriceFeed(
      ethers.ZeroAddress,
      ethers.getAddress("0x694AA1769357215DE4FAC081bf1f309aDC325306")
    );

    // deployer余额
    const user1BalanceBefore = await ethers.provider.getBalance(deployer.address);
    console.log("deployer余额:", user1BalanceBefore);

    // 首次出价EHT
    console.log("首次出价EHT")
    await AuctionContract.connect(user1).priceBid(1, 1, { value: ethers.parseEther("1") });

    // 查询出价记录
    const _bidInfo = await AuctionContract.getBidItem(1);
    console.log("======查询出价=====", _bidInfo)

    // 更高ETH出价
    console.log("======更高ETH出价=====")
    await AuctionContract.connect(user2).priceBid(1, 2, { value: ethers.parseEther("2") });

    // 验证前一个出价者的ETH是否被退回
    const user1Balance = await ethers.provider.getBalance(user1.address);
    console.log("user1余额:", user1Balance);

    // 查询出价记录
    const _bidInfo2 = await AuctionContract.getBidItem(1);
    console.log("======查询出价记录=====", _bidInfo2)


    // 结束拍卖
    console.log("======结束拍卖=====")
    await AuctionContract.endAuction(1);

    // 查询拍卖信息
    const _auctionInfo2 = await AuctionContract.getAuctionItem(1);
    console.log("======查询结束拍卖信息=====", _auctionInfo2)

  });
});