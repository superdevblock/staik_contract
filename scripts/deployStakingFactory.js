const { ethers } = require("hardhat");

async function main() {
  const contract = await ethers.getContractFactory("TokenStaking");
  const staking = await contract.deploy("0x4e0f76fa1fc5430464dd8397e9e2d4eeb0a76cdb", 
                                    "0x4e0f76fa1fc5430464dd8397e9e2d4eeb0a76cdb",
                                    365,
                                    270,
                                    5,
                                    120);

  console.log("This is Staking contract address: ", staking.address);
}

main();