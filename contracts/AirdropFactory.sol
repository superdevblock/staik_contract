//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirdropFactory is Ownable {
    address public tokenAddress =
        address(0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970); // Replace with your token contract address
    IERC20 public token = IERC20(tokenAddress);
    address[] public recipients;
    uint256 public amountPerRecipient = 100; // Replace with the amount of tokens to be distributed per recipient

    function setRecipients(address[] memory _recipients) external onlyOwner {
        recipients = _recipients;
    }

    function airdropToken(
        address[] memory _recipients,
        uint256 _amount
    ) external onlyOwner {
        for (uint256 i = 0; i < _recipients.length; i++) {
            token.transferFrom(msg.sender, _recipients[i], _amount);
        }
    }

    function setTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function setAirdropCount(uint256 _amount) external onlyOwner {
        amountPerRecipient = _amount;
    }
}
