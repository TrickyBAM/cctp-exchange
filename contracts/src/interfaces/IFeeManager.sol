// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFeeManager {
    struct FeeTier {
        uint256 maxAmount;
        uint16 feeBasisPoints;
    }

    event FeeCalculated(address indexed user, uint256 amount, uint256 feeAmount, uint16 feeBasisPoints);
    event FeeWalletUpdated(address indexed oldWallet, address indexed newWallet, address indexed updatedBy);
    event FeeTiersUpdated(address indexed updatedBy, uint256 tierCount);

    error ZeroAmount();
    error ZeroAddress();
    error InvalidFeeTiers();
    error InvalidBasisPoints(uint16 basisPoints);
    error TiersNotAscending();

    function calculateFee(uint256 amount) external view returns (uint256 feeAmount, uint16 feeBasisPoints);
    function feeWallet() external view returns (address);
    function getFeeTiers() external view returns (FeeTier[] memory);
}
