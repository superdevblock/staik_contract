# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deployStakingFactory.js --network bscTestnet
npx hardhat verify --network bsc --contract contracts/TokenStaking.sol:TokenStaking 0x977405CeB99fE83e615BFf163F677D14134a3a79 "0x2dFee2792f4b4CC939F8274B60fEaaE756fA941E", "0x2dFee2792f4b4CC939F8274B60fEaaE756fA941E", 365, 270, 5, 120

npx hardhat verify 0x5EA2dbc5Aec49E1474835890e5E4a5c501396662 --network bscTestnet



```
