//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

import "./IGainProtocol.sol";
import "./AggregatorV3Interface.sol";
import "./SafeMath.sol";

contract GainPriceFeed {
    using SafeMath for uint256;

    AggregatorV3Interface public immutable priceFeed;
    IGainProtocol internal immutable token;

    constructor(IGainProtocol _token, AggregatorV3Interface _priceFeed) public {
        token = _token;
        priceFeed = _priceFeed;
    }

    /**
     * @dev returns value of _usd in gains.
     */
    function gainsForUSD(uint256 _usd)
        external
        view
        returns (bool success, uint256 value)
    {
        (uint256 gainReserve, uint256 bnbReserve) = this.getReserves();
        if (gainReserve == 0 || bnbReserve == 0) {
            return (false, 0);
        }
        (bool internalSuccess, int256 usdToBNB) = this.usdBNBPrice();
        if (usdToBNB == 0) {
            return (false, 0);
        }
        success = internalSuccess;
        /*
            10**8 - decimals
            USDs * (1/(USD price for bnb/10**8)) * (GAIN/BNB)
            USDs * GAIN * 10**8 /USD price / BNB
        */
        value = _usd
        .mul(gainReserve)
        .mul(uint256(10)**(priceFeed.decimals() + 18)) // to remove decimals from usd price, and from BNB
            .div(uint256(usdToBNB))
            .div(bnbReserve);
    }

    /**
     * @dev Get LP reserves for GAIN/BNB
     * returns (gainReserve, BNBReserve)
     */
    function getReserves() external view returns (uint256, uint256) {
        IUniswapV2Pair pair = token.uniswapV2Pair();
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        return
            pair.token0() == address(token)
                ? (reserve0, reserve1)
                : (reserve1, reserve0);
    }

    /**
     * @dev get BNB price in USD. if latestRoundData throws, returns (false, 0)
     */
    function usdBNBPrice() public view returns (bool success, int256 value) {
        try priceFeed.latestRoundData() returns (
            uint80, /*roundId*/
            int256 answer,
            uint256, /*startedAt*/
            uint256, /*updatedAt*/
            uint80 /*answeredInRound*/
        ) {
            value = answer;
            success = true;
        } catch {
            success = false;
            value = 0;
        }
    }

    function usdBNBDecimals() external view returns (uint256) {
        return priceFeed.decimals();
    }

    function usdToBNB(uint256 usd) external view returns (uint256 bnb) {
        (bool priceSuccess, int256 usdToBNBRate) = usdBNBPrice();
        require(priceSuccess, "Internal pricing error");

        bnb = usd.mul(1 ether).mul(uint256(10)**priceFeed.decimals()).div(
            uint256(usdToBNBRate)
        );
    }
}
