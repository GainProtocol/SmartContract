//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

import "./IERC20.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Pair.sol";

interface IGainProtocol is IERC20 {
    function startDraw() external;

    function setAssociate(address _associate) external;

    function dailyTransfersOf(address _account) external view returns (uint256);

    function tokenFromReflection(uint256 _rAmount)
        external
        view
        returns (uint256);

    function reflectionFromToken(uint256 _tAmount)
        external
        view
        returns (uint256);

    function collectedSweepstake() external view returns (uint256);

    function collectedLiquidity() external view returns (uint256);

    function collectedCharity() external view returns (uint256);

    function collectedWhaleFee() external view returns (uint256);

    function collectedReward() external view returns (uint256);

    function collectedTeamFee() external view returns (uint256);

    function collectedHodlReward() external view returns (uint256);

    function soldLiquidity() external view returns (uint256);

    function availableSweepstake() external view returns (uint256);

    function availableCharity() external view returns (uint256);

    function availableLiquidity() external view returns (uint256);

    function transferSweepstake(address _winner, uint256 _tAmount) external;

    function calculateFees(
        address _sender,
        address _recipient,
        uint256 _tAmount
    )
        external
        view
        returns (
            uint256 liquidityFee,
            uint256 sweepstakeFee,
            uint256 teamFee,
            uint256 charityFee,
            uint256 rewardFee,
            uint256 hodlFee,
            uint256 whaleProtectionFee
        );

    function lockedBalanceReleaseDate(address _account)
        external
        view
        returns (uint256);

    function lockedBalanceOf(address _account) external view returns (uint256);

    function hodlTokensOf(address _account)
        external
        view
        returns (uint256 hodlTokens, uint256 hodlTokenSupply);

    function giveBack(uint256 _tAmount) external;

    function giveBackHodl(uint256 _tAmount) external;

    function lockedTransfer(
        address _to,
        uint256 _tAmount,
        uint256 _lockPeriodSeconds
    ) external;

    function lockTokens(uint256 _tAmount, uint256 _lockPeriodSeconds) external;

    function uniswapV2Pair() external view returns (IUniswapV2Pair);

    function uniswapV2Router() external view returns (IUniswapV2Router02);
}
