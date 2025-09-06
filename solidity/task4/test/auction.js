const { ethers, deployments } = require("hardhat");
const { expect } = require("chai");

describe("Auction", async () => {
  /*it("Should create an auction", async function () {
    const Auction = await ethers.getContractFactory("Auction");
    const auction = await Auction.deploy();
    auction.waitForDeployment();

    await auction.createAuction(
      ethers.ZeroAddress,
      50000,
      1620233,
      5000,
      10
    )
    const auctionInfo = await auction.bids(1);
    console.log("======创建拍卖=====", auctionInfo);

    // 出价
    await auction.bidprice(1, 50000);
    const _auctionInfo = await auction.bids(1);
    console.log("======出价=====", _auctionInfo)
  });*/

  it("Test upgrade", async function () {
    // 部署实现合约
    await deployments.fixture(["deployAuction"]);

    const auctionProxy = await deployments.get("AuctionProxy");
    console.log("======代理合约地址=====", auctionProxy.address);

    // 调用创建拍卖方法
    const auctionContract = await ethers.getContractAt("Auction", auctionProxy.address);
    await auctionContract.createAuction(
      ethers.ZeroAddress,
      50000,
      1620233,
      5000,
      10
    )
    const bid1 = await auctionContract.bids(0);
    console.log("======创建拍卖bid1=====", bid1);

    // 升级合约
    await deployments.fixture(["upgradeAuction"]);
    const auctionV2Proxy = await deployments.get("AuctionV2Proxy");
    const auctionV2Contract = await ethers.getContractAt("AuctionV2", auctionV2Proxy.address);
    const bid2 = await auctionV2Contract.bids(0)
    console.log("======创建拍卖bid2=====", bid2);

    const test = await auctionV2Contract.test()
    console.log("======test=====", test);

    expect(bid1.startTime).to.equal(bid2.startTime);
  })
});