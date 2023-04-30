const { ethers } = require("hardhat");

async function main() {
  const contract = await ethers.getContractFactory("STAIKToken");
  const token = await contract.deploy();

  console.log("This is Token contract address: ", token.address);
}

main();