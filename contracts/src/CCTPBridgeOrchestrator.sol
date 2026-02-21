// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IFeeManager} from "./interfaces/IFeeManager.sol";
import {ITreasury} from "./interfaces/ITreasury.sol";

contract CCTPBridgeOrchestrator is Initializable, UUPSUpgradeable, AccessControlUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeERC20 for IERC20;

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    IFeeManager public feeManager;
    ITreasury public treasury;
    address public usdcToken;
    mapping(bytes32 transferId => bool processed) public processedTransfers;
    uint256 public totalTransfers;
    uint256 public totalVolume;
    uint256 public totalFeesCollected;

    event BridgeFeeCollected(bytes32 indexed transferId, address indexed user, uint256 amount, uint256 feeAmount, uint16 feeBasisPoints, uint256 netAmount, uint32 sourceDomain);
    event ContractReferencesUpdated(address indexed feeManager, address indexed treasury, address indexed usdcToken);
    event TransferRegistered(bytes32 indexed transferId, address indexed user, uint256 amount, uint32 sourceDomain);

    error TransferAlreadyProcessed(bytes32 transferId);
    error ZeroAmount();
    error ZeroAddress();
    error FeeWalletNotSet();
    error InsufficientBalance(uint256 required, uint256 available);
    error InsufficientAllowance(uint256 required, uint256 available);

    uint256[40] private __gap;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() { _disableInitializers(); }

    function initialize(address admin, address _feeManager, address _treasury, address _usdcToken) external initializer {
        if (admin == address(0) || _feeManager == address(0) || _treasury == address(0) || _usdcToken == address(0)) revert ZeroAddress();
        __UUPSUpgradeable_init();
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(OPERATOR_ROLE, admin);
        _grantRole(UPGRADER_ROLE, admin);
        _grantRole(PAUSER_ROLE, admin);
        feeManager = IFeeManager(_feeManager);
        treasury = ITreasury(_treasury);
        usdcToken = _usdcToken;
        emit ContractReferencesUpdated(_feeManager, _treasury, _usdcToken);
    }

    function collectFee(bytes32 transferId, uint256 amount, uint32 sourceDomain) external whenNotPaused nonReentrant {
        if (amount == 0) revert ZeroAmount();
        if (processedTransfers[transferId]) revert TransferAlreadyProcessed(transferId);
        address currentFeeWallet = feeManager.feeWallet();
        if (currentFeeWallet == address(0)) revert FeeWalletNotSet();
        (uint256 feeAmount, uint16 feeBasisPoints) = feeManager.calculateFee(amount);
        uint256 userBalance = IERC20(usdcToken).balanceOf(msg.sender);
        if (userBalance < feeAmount) revert InsufficientBalance(feeAmount, userBalance);
        uint256 userAllowance = IERC20(usdcToken).allowance(msg.sender, address(this));
        if (userAllowance < feeAmount) revert InsufficientAllowance(feeAmount, userAllowance);
        processedTransfers[transferId] = true;
        totalTransfers += 1;
        totalVolume += amount;
        totalFeesCollected += feeAmount;
        uint256 netAmount = amount - feeAmount;
        if (feeAmount > 0) {
            IERC20(usdcToken).safeTransferFrom(msg.sender, currentFeeWallet, feeAmount);
        }
        emit BridgeFeeCollected(transferId, msg.sender, amount, feeAmount, feeBasisPoints, netAmount, sourceDomain);
    }

    function registerTransfer(bytes32 transferId, address user, uint256 amount, uint32 sourceDomain) external onlyRole(OPERATOR_ROLE) whenNotPaused {
        if (processedTransfers[transferId]) revert TransferAlreadyProcessed(transferId);
        processedTransfers[transferId] = true;
        totalTransfers += 1;
        totalVolume += amount;
        emit TransferRegistered(transferId, user, amount, sourceDomain);
    }

    function updateContractReferences(address _feeManager, address _treasury, address _usdcToken) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (_feeManager == address(0) || _treasury == address(0) || _usdcToken == address(0)) revert ZeroAddress();
        feeManager = IFeeManager(_feeManager);
        treasury = ITreasury(_treasury);
        usdcToken = _usdcToken;
        emit ContractReferencesUpdated(_feeManager, _treasury, _usdcToken);
    }

    function previewFee(uint256 amount) external view returns (uint256 feeAmount, uint256 netAmount, uint16 feeBasisPoints) {
        (feeAmount, feeBasisPoints) = feeManager.calculateFee(amount);
        netAmount = amount - feeAmount;
    }

    function isTransferProcessed(bytes32 transferId) external view returns (bool) { return processedTransfers[transferId]; }
    function pause() external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
