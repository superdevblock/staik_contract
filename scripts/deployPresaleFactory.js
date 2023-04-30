const { ethers, upgrades } = require("hardhat");

async function main() {
  const PresaleFactoryFee = await ethers.getContractFactory("PresaleFactoryFee");
  const proxy = await upgrades.deployProxy(PresaleFactoryFee, [], { initializer: 'initialize' } );
  await proxy.deployed();

  console.log("This is PresaleFactoryFee contract address: ", proxy.address);
}

main();