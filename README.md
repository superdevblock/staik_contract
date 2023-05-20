# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deployStakingFactory.js --network bscTestnet
npx hardhat verify --network bscTestnet --contract contracts/TokenStaking.sol:TokenStaking 0x59d0b6EbEA5E3F3C2c247aD1deEe181bf2256189 "0x4e0f76fa1fc5430464dd8397e9e2d4eeb0a76cdb", "0x4e0f76fa1fc5430464dd8397e9e2d4eeb0a76cdb", 365, 270, 5, 120

npx hardhat verify 0x5EA2dbc5Aec49E1474835890e5E4a5c501396662 --network bscTestnet



```
