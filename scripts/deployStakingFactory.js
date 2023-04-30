const { ethers } = require("hardhat");

async function main() {
  const contract = await ethers.getContractFactory("TokenStaking");
  const staking = await contract.deploy("0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970", 
                                    "0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970",
                                    360,
                                    150);

  console.log("This is Staking contract address: ", staking.address);
}

main();