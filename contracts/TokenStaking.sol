/**
 *Submitted for verification at "BSC" on 2023-04-23
 */

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
/**************************************
 **************************************
 Telegram: https://t.me/valuableblockchaintalent 
 **************************************
 **************************************
*/
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenStaking is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 public stakingToken;
    IERC20 public rewardToken;
    uint256 public lockDuration;
    uint256 public totalStaked;
    uint256 public totalAccountCount;
    uint256 public dailyRewardRate;
    uint256 public daySecond;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastStakeTime;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event Claimed(address indexed user, uint256 amount);

    constructor(
        address _stakingToken,
        address _rewardToken,
        uint256 _lockDuration,
        uint256 _dailyRewardRate
    ) {
        daySecond = 86400;

        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        lockDuration = _lockDuration * daySecond;
        dailyRewardRate = _dailyRewardRate; // 150

        totalAccountCount = 0;
    }

    function StakingToken(uint256 amount) external nonReentrant {
        require(amount > 0, "Staking: amount must be greater than 0");
        require(
            stakingToken.balanceOf(msg.sender) >= amount,
            "Staking: insufficient balance"
        );
        require(
            stakingToken.allowance(msg.sender, address(this)) >= amount,
            "Staking: insufficient allowance"
        );
        // get and send reward
        uint256 reward = calculateReward(msg.sender);
        if (reward > 0) {
            rewardToken.safeTransfer(msg.sender, reward);
            emit Claimed(msg.sender, reward);
        }

        stakingToken.safeTransferFrom(msg.sender, address(this), amount);

        if (stakedBalance[msg.sender] == 0) {
            stakedBalance[msg.sender] = amount;
            totalAccountCount++;
        } else if (stakedBalance[msg.sender] > 0)
            stakedBalance[msg.sender] = stakedBalance[msg.sender].add(amount);

        totalStaked = totalStaked.add(amount);
        lastStakeTime[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function UnstakingToken() external nonReentrant {
        require(
            stakedBalance[msg.sender] > 0,
            "Staking: no balance to unstake"
        );

        uint256 amount = stakedBalance[msg.sender];
        uint256 reward = calculateReward(msg.sender);
        uint256 tax = 0;

        if (reward > 0) {
            rewardToken.safeTransfer(msg.sender, reward);
        }

        if (block.timestamp <= lastStakeTime[msg.sender].add(lockDuration))
            tax = amount.mul(30).div(100);

        stakingToken.safeTransfer(msg.sender, amount.sub(tax));

        totalAccountCount--;
        stakedBalance[msg.sender] = 0;
        lastStakeTime[msg.sender] = 0;

        totalStaked = totalStaked.sub(amount);

        emit Unstaked(msg.sender, amount);
    }

    function getClaimToken(address _user) external {
        // get and send reward
        uint256 reward = calculateReward(_user);
        uint256 realReward = reward.mul(70).div(100);
        if (realReward > 0) {
            rewardToken.safeTransfer(msg.sender, realReward);
            lastStakeTime[msg.sender] = block.timestamp;
            emit Claimed(msg.sender, realReward);
        }
    }

    function withDrawToken() external onlyOwner {
        uint256 balanceToken = stakingToken.balanceOf(address(this));
        stakingToken.transfer(msg.sender, balanceToken);
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp.sub(lastStakeTime[user]);
        timeElapsed = timeElapsed.div(daySecond);
        uint256 reward = stakedBalance[user]
            .mul(dailyRewardRate)
            .mul(timeElapsed)
            .div(10 ** 4);
        return reward;
    }

    function setAddressStakingToken(address _stakingToken) external onlyOwner {
        stakingToken = IERC20(_stakingToken);
    }

    function setAddressRewardToken(address _rewardToken) external onlyOwner {
        rewardToken = IERC20(_rewardToken);
    }

    function setlockDuration(uint256 _lockDuration) external onlyOwner {
        lockDuration = uint256(_lockDuration * daySecond);
    }

    function setDailyRewardRate(uint256 _dailyRewardRate) external onlyOwner {
        dailyRewardRate = _dailyRewardRate;
    }

    function setDaySecond(uint256 secondCount) external onlyOwner {
        daySecond = secondCount;
    }

    function showClaimToken(address _user) external view returns (uint256) {
        return calculateReward(_user);
    }

    function getCurrentTime() external view returns (uint256) {
        return block.timestamp;
    }
}
