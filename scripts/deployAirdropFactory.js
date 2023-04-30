const { ethers } = require("hardhat");

async function main() {
  const airdrop = await ethers.getContractFactory("AirdropFactory");
  const token = await airdrop.deploy();

  console.log("This is Airdrop contract address: ", token.address);
}

main();