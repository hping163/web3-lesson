const { ethers, upgrades } = require('hardhat');

module.exports = async function () {
  const [deployer] = await ethers.getSigners();

  // 部署实现合约
  const Implementation = await ethers.getContractFactory("HImplemention");
  const implementation = await Implementation.deploy();
  await implementation.waitForDeployment();

  // 部署信标合约
  const beacon = await upgrades.deployBeacon(Implementation);
  await beacon.waitForDeployment();

  // 部署代理合约
  const proxy = await upgrades.deployBeaconProxy(beacon, Implementation, []);
  await proxy.waitForDeployment();

  console.log("实现合约地址:", await implementation.getAddress());
  console.log("信标合约地址:", await beacon.getAddress());
  console.log("代理合约地址:", await proxy.getAddress());

}

module.exports.tags = ['deployBeacon'];


/*async function main() {
  // 部署实现合约
  const Implementation = await ethers.getContractFactory("HImplemention");
  const implementation = await Implementation.deploy();
  await implementation.waitForDeployment();

  // 部署信标合约
  const Beacon = await ethers.getContractFactory("HBeacon");
  const beacon = await upgrades.deployBeacon(Implementation);
  await beacon.waitForDeployment();

  // 部署代理合约
  const Proxy = await ethers.getContractFactory("HProxy");
  const proxy = await upgrades.deployBeaconProxy(beacon, Implementation, []);
  await proxy.waitForDeployment();

  console.log("实现合约地址:", await implementation.getAddress());
  console.log("信标合约地址:", await beacon.getAddress());
  console.log("代理合约地址:", await proxy.getAddress());
}

main()*/
