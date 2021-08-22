//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

interface IGainProtocolTransferListener {
    function onTransfer(
        address _from,
        address _to,
        uint256 _tAmount,
        uint256 _liquidityFee,
        uint256 _sweepstakeFee,
        uint256 _teamFee,
        uint256 _charityFee,
        uint256 _rewardFee,
        uint256 _hodlFee,
        uint256 _whaleProtection,
        uint256 _tTransferAmount,
        uint256 _sellerBalance
    ) external;
}
