// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITreasury {
    event FeeDeposited(address indexed token, address indexed from, uint256 amount, bytes32 indexed transferId);
    event FeeWithdrawn(address indexed token, address indexed to, uint256 amount, address indexed withdrawnBy);
    event EmergencyWithdrawal(address indexed token, address indexed to, uint256 amount, address indexed withdrawnBy);

    error ZeroAmount();
    error ZeroAddress();
    error TransferFailed();
    error InsufficientBalance(uint256 requested, uint256 available);

    function depositFee(address token, uint256 amount, bytes32 transferId) external;
    function withdraw(address token, address to, uint256 amount) external;
    function getBalance(address token) external view returns (uint256);
}
