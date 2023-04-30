const { ethers, upgrades } = require("hardhat");

// TO DO: Place the address of your proxy here!
const proxyAddress = "0xD9078f6F4078B37CBAA81C96956e5C6231a62106";

async function main() {
  const presale = await ethers.getContractFactory("PresaleFactoryFee");
  const upgraded = await upgrades.upgradeProxy(proxyAddress, presale);
  console.log("PresaleFactory contract is upgraded!", upgraded.address);
}

main() 
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });