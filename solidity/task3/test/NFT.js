const { ethers } = require("hardhat");

describe("MyNFT", async function () {
  it("Should deploy the contract", async function () {
    const MyNFT = await ethers.getContractFactory("NFT");
    const myNFT = await MyNFT.deploy();
    await myNFT.waitForDeployment();
    const contractAddress = await myNFT.getAddress();
    console.log("======合约地址=====", contractAddress);

    // 初始化
    await myNFT.initialize("MyNFT", "MNFT");
    // 检查合约名称和符号
    const name = await myNFT.name();
    const symbol = await myNFT.symbol();
    console.log("======合约名称=====", name);
    console.log("======合约符号=====", symbol);

    // 铸造NFT
    await myNFT.mintNFT(contractAddress, "https://olive-genetic-whale-994.mypinata.cloud/ipfs/bafkreiehkktvfv3eo2dqds4bjtj6ti5f5wyxalbjvz2ca5dfnwuequjvyq");

    // 等待1秒
    await new Promise(resolve => setTimeout(resolve, 1000));

    // 检查NFT是否正确铸造
    const tokenURI = await myNFT.tokenURI(1);
    console.log("======tokenURI=====", tokenURI);

    // 更新tokenURI
    await myNFT.setTokenURI(1, "https://www.baidu.com");

    // 检查tokenURI是否更新
    const tokenURI2 = await myNFT.tokenURI(1);
    console.log("======tokenURI2=====", tokenURI2);

  });
});