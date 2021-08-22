//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

import "./IGainProtocol.sol";
import "./IGainProtocolTransferListener.sol";

interface IGainSweepstakes is IGainProtocolTransferListener {
    enum SweepstakeTypes {
        EqualChance,
        ByHoldingSize,
        Minigame,
        DailyBuyers,
        BigHolders,
        Seniority,
        NewHolders
    }

    struct SweepstakeWinInfo {
        address winner;
        uint256 amount;
        SweepstakeTypes sweepstakeType;
    }

    struct SweepstakeResult {
        uint256 performedAt;
        uint256 sweepstakeID;
        uint256 totalJackpot;
        uint256 minigameRandom;
        SweepstakeWinInfo[] winners;
    }

    function sweepstakeCount() external view returns (uint256);

    function setParentERC(IGainProtocol _parentToken) external;

    function sweepstakeResult(uint256 index)
        external
        view
        returns (
            uint256 performedAt,
            uint256 sweepstakeID,
            uint256 totalJackpot,
            uint256 minigameRandom,
            address[] memory winners,
            uint256[] memory amounts,
            SweepstakeTypes[] memory types
        );

    function initialTransfer(
        address _to,
        uint256 /*_tAmount*/
    ) external;

    function startDraw(uint256 tSweepstakeAmount) external;
}
