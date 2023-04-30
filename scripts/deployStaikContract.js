const { ethers, upgrades } = require("hardhat");

async function main() {
  const Token = await ethers.getContractFactory("STAIKToken");
  const token = await Token.deploy();

  console.log("This is Staik token contract address: ", token.address);
}

main();