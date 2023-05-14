# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deployStakingFactory.js --network bscTestnet
npx hardhat verify --network bscTestnet --contract contracts/TokenStaking.sol:TokenStaking 0x87e8206BD8Ad60E5dE7894B5FF0044e51e75c246 "0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970", "0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970", 360, 150

npx hardhat verify 0x5EA2dbc5Aec49E1474835890e5E4a5c501396662 --network bscTestnet



```
