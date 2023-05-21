const { ethers } = require("hardhat");

async function main() {
  const contract = await ethers.getContractFactory("TokenStaking");
  const staking = await contract.deploy("0x2dFee2792f4b4CC939F8274B60fEaaE756fA941E", 
                                    "0x2dFee2792f4b4CC939F8274B60fEaaE756fA941E",
                                    365,
                                    270,
                                    5,
                                    120);

  console.log("This is Staking contract address: ", staking.address);
}

main();