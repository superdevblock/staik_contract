/**
 * Submitted for verification at "BSC" on 2023-04-23
 */

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
/**************************************
 **************************************
 Telegram: https://t.me/valuableblockchaintalent 
 **************************************
 **************************************
*/

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../contracts/IDEXRouter01.sol";

contract PresaleFactoryFee is OwnableUpgradeable {
    IERC20 public staikAddress;
    IERC20 public usdtAddress;
    IERC20 public busdAddress;
    IERC20 public wbtcAddress;
    IERC20 public wethAddress;

    uint256 public startTime;
    uint256 public endTime;

    uint256 public tokenPrice_USD;

    IDEXRouter01 public bsc01Router;

    mapping(address => uint256) private userPaid_BNB;
    mapping(address => uint256) private userPaid_BUSD;
    mapping(address => uint256) private userPaid_USDT;
    mapping(address => uint256) private userPaid_WETH;
    mapping(address => uint256) private userPaid_WBTC;

    AggregatorV3Interface internal bnbPriceFeed;
    AggregatorV3Interface internal ethPriceFeed;
    AggregatorV3Interface internal btcPriceFeed;

    address public wallet1;
    address public wallet2;
    address public wallet3;

    uint256 public fee1;
    uint256 public fee2;
    uint256 public fee3;

    uint256 feeDenominator;

    function initialize() public initializer {
        __Ownable_init();

        startTime = 1677423600;
        endTime = 1690815600;

        tokenPrice_USD = 5 * 10 ** 16;

        bnbPriceFeed = AggregatorV3Interface(
            0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526
        );
        ethPriceFeed = AggregatorV3Interface(
            0x143db3CEEfbdfe5631aDD3E50f7614B6ba708BA7
        );
        btcPriceFeed = AggregatorV3Interface(
            0x5741306c21795FdCBb9b265Ea0255F499DFe515C
        );

        wallet1 = 0xCA1269CfAbA5469C7Bcfbd96c193c1E1A4425C8e;
        wallet2 = 0x879ea0A46495b761be84F08fA59f1461c565197b;
        wallet3 = 0xE9125b6DAC33f092c592a28695Bb6630D1754f37;

        fee1 = 25;
        fee2 = 25;
        fee3 = 950;
        feeDenominator = 1000;

        staikAddress = IERC20(0xD1E1B33EC6229F6FDb9d282C580e84273aeaD970);
        usdtAddress = IERC20(0x337610d27c682E347C9cD60BD4b3b107C9d34dDd);
        busdAddress = IERC20(0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7);
        wbtcAddress = IERC20(0x1f12b61a35ca147542001186DEA23e34eb4d7d95);
        wethAddress = IERC20(0x1e33833a035069f42d68D1F53b341643De1C018D);
    }

    function buyTokensByWETH(uint256 _amountPrice) external {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "PresaleFactory: Not presale period"
        );

        int256 _wethPrice = getWETHPrice() / 10 ** 8;
        uint256 wethPrice = uint256(_wethPrice);

        // token amount user want to buy
        uint256 amountPrice = wethPrice * _amountPrice;

        uint256 tokenAmount = amountPrice / tokenPrice_USD;
        uint256 decimalTokenAmount = tokenAmount * 10 ** 18;

        wethAddress.transferFrom(
            msg.sender,
            wallet1,
            (_amountPrice * fee1) / feeDenominator
        );
        wethAddress.transferFrom(
            msg.sender,
            wallet2,
            (_amountPrice * fee2) / feeDenominator
        );
        wethAddress.transferFrom(
            msg.sender,
            wallet3,
            (_amountPrice * fee3) / feeDenominator
        );

        // transfer staik token to user
        staikAddress.transfer(msg.sender, decimalTokenAmount);

        // add weth user bought
        userPaid_WETH[msg.sender] += _amountPrice;

        emit Presale(address(this), msg.sender, decimalTokenAmount);
    }

    function buyTokensByBNB() external payable {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "PresaleFactory: Not presale period"
        );
        require(msg.value > 0, "Insufficient BNB amount");

        int256 _bnbPrice = getBNBPrice() / 10 ** 8;
        uint256 bnbPrice = uint256(_bnbPrice);

        // token amount user want to buy
        uint256 amountPrice = bnbPrice * msg.value;

        uint256 tokenAmount = amountPrice / tokenPrice_USD ** 18;
        uint256 decimalTokenAmount = tokenAmount;

        staikAddress.transfer(msg.sender, decimalTokenAmount);

        // add bnb user bought
        userPaid_BNB[msg.sender] += msg.value;

        emit Presale(address(this), msg.sender, decimalTokenAmount);
    }

    function buyTokensByUSDT(uint256 _amountPrice) external {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "PresaleFactory: Not presale period"
        );

        // token amount user want to buy
        uint256 tokenAmount = _amountPrice / tokenPrice_USD;
        uint256 decimalTokenAmount = tokenAmount * 10 ** 18;

        usdtAddress.transferFrom(
            msg.sender,
            wallet1,
            (_amountPrice * fee1) / feeDenominator
        );
        usdtAddress.transferFrom(
            msg.sender,
            wallet2,
            (_amountPrice * fee2) / feeDenominator
        );
        usdtAddress.transferFrom(
            msg.sender,
            wallet3,
            (_amountPrice * fee3) / feeDenominator
        );
        // transfer staik token to user
        staikAddress.transfer(msg.sender, decimalTokenAmount);

        // add USDT user bought
        userPaid_USDT[msg.sender] += _amountPrice;

        emit Presale(address(this), msg.sender, decimalTokenAmount);
    }

    function buyTokensByBUSD(uint256 _amountPrice) external payable {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "PresaleFactory: Not presale period"
        );

        // token amount user want to buy
        uint256 tokenAmount = _amountPrice / tokenPrice_USD;
        uint256 decimalTokenAmount = tokenAmount * 10 ** 18;

        busdAddress.transferFrom(
            msg.sender,
            wallet1,
            (_amountPrice * fee1) / feeDenominator
        );
        busdAddress.transferFrom(
            msg.sender,
            wallet2,
            (_amountPrice * fee2) / feeDenominator
        );
        busdAddress.transferFrom(
            msg.sender,
            wallet3,
            (_amountPrice * fee3) / feeDenominator
        );

        // transfer staik token to user
        staikAddress.transfer(msg.sender, decimalTokenAmount);

        // add USDT user bought
        userPaid_BUSD[msg.sender] += _amountPrice;

        emit Presale(address(this), msg.sender, decimalTokenAmount);
    }

    function buyTokensByWBTC(uint256 _amountPrice) external {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "PresaleFactory: Not presale period"
        );

        int256 _wbtcPrice = getWBTCPrice() / 10 ** 8;
        uint256 wbtcPrice = uint256(_wbtcPrice);

        // token amount user want to buy
        uint256 amountPrice = wbtcPrice * _amountPrice;

        uint256 tokenAmount = amountPrice / tokenPrice_USD;
        uint256 decimalTokenAmount = tokenAmount * 10 ** 18;

        wbtcAddress.transferFrom(
            msg.sender,
            wallet1,
            (_amountPrice * fee1) / feeDenominator
        );
        wbtcAddress.transferFrom(
            msg.sender,
            wallet2,
            (_amountPrice * fee2) / feeDenominator
        );
        wbtcAddress.transferFrom(
            msg.sender,
            wallet3,
            (_amountPrice * fee3) / feeDenominator
        );
        // transfer staik token to user
        staikAddress.transfer(msg.sender, decimalTokenAmount);

        // add USDT user bought
        userPaid_WBTC[msg.sender] += _amountPrice;

        emit Presale(address(this), msg.sender, decimalTokenAmount);
    }

    function getBNBPrice() public view returns (int) {
        (, int price, , , ) = bnbPriceFeed.latestRoundData();
        return price;
    }

    function getWETHPrice() public view returns (int) {
        (, int price, , , ) = ethPriceFeed.latestRoundData();
        return price;
    }

    function getWBTCPrice() public view returns (int) {
        (, int price, , , ) = btcPriceFeed.latestRoundData();
        return price;
    }

    function getLatestBNBPrice(uint256 _amount) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = bsc01Router.WETH();
        path[1] = address(busdAddress);

        uint256[] memory price_out = bsc01Router.getAmountsOut(_amount, path);
        return price_out[1];
    }

    function withdrawAll() external onlyOwner {
        uint256 BNBbalance = address(this).balance;
        uint256 BUSDbalance = busdAddress.balanceOf(address(this));
        uint256 USDTbalance = usdtAddress.balanceOf(address(this));
        uint256 WBTCbalance = wbtcAddress.balanceOf(address(this));
        uint256 WETHbalance = wethAddress.balanceOf(address(this));

        if (BNBbalance > 0) {
            payable(wallet1).transfer((BNBbalance * fee1) / feeDenominator);
            payable(wallet2).transfer((BNBbalance * fee2) / feeDenominator);
            payable(wallet3).transfer((BNBbalance * fee3) / feeDenominator);
        }

        if (BUSDbalance > 0) busdAddress.transfer(owner(), BUSDbalance);
        if (USDTbalance > 0) usdtAddress.transfer(owner(), USDTbalance);
        if (WBTCbalance > 0) wbtcAddress.transfer(owner(), WBTCbalance);
        if (WETHbalance > 0) wethAddress.transfer(owner(), WETHbalance);

        emit WithdrawAll(msg.sender, 0);
    }

    function withdrawToken() public onlyOwner returns (bool) {
        // require(block.timestamp > endTime);

        uint256 balance = staikAddress.balanceOf(address(this));
        return staikAddress.transfer(msg.sender, balance);
    }

    function getUserPaidUSDT() public view returns (uint256) {
        return userPaid_USDT[msg.sender];
    }

    function getUserPaidBUSD() public view returns (uint256) {
        return userPaid_BUSD[msg.sender];
    }

    function getUserPaidBNB() public view returns (uint256) {
        return userPaid_BNB[msg.sender];
    }

    function getUserPaidWBTC() public view returns (uint256) {
        return userPaid_WBTC[msg.sender];
    }

    function getUserPaidWETH() public view returns (uint256) {
        return userPaid_WETH[msg.sender];
    }

    function setTokenPriceUSD(uint256 _tokenPrice) public onlyOwner {
        tokenPrice_USD = _tokenPrice;
    }

    function setStartTime(uint256 _startTime) public onlyOwner {
        startTime = _startTime;
    }

    function setEndTime(uint256 _endTime) public onlyOwner {
        endTime = _endTime;
    }

    function setstaikTokenAddress(address _address) public onlyOwner {
        staikAddress = IERC20(_address);
    }

    function setRouterAddress(address _address) public onlyOwner {
        bsc01Router = IDEXRouter01(_address);
    }

    function setBusdAddress(address _address) public onlyOwner {
        busdAddress = IERC20(_address);
    }

    function setUsdtAddress(address _address) public onlyOwner {
        usdtAddress = IERC20(_address);
    }

    function setWbtcAddress(address _address) public onlyOwner {
        wbtcAddress = IERC20(_address);
    }

    function setWethAddress(address _address) public onlyOwner {
        wethAddress = IERC20(_address);
    }

    event Presale(address _from, address _to, uint256 _amount);
    event SetStartTime(uint256 _time);
    event SetEndTime(uint256 _time);
    event WithdrawAll(address addr, uint256 usdt);

    receive() external payable {}

    fallback() external payable {}
}
