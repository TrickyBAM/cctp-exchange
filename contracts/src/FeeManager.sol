// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IFeeManager} from "./interfaces/IFeeManager.sol";

contract FeeManager is Initializable, UUPSUpgradeable, AccessControlUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable, IFeeManager {
    uint16 public constant MAX_BASIS_POINTS = 10_000;
    uint8 public constant USDC_DECIMALS = 6;
    bytes32 public constant FEE_MANAGER_ROLE = keccak256("FEE_MANAGER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    address private _feeWallet;
    FeeTier[] private _feeTiers;
    uint256[48] private __gap;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() { _disableInitializers(); }

    function initialize(address admin, address initialFeeWallet) external initializer {
        if (admin == address(0)) revert ZeroAddress();
        __UUPSUpgradeable_init();
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(FEE_MANAGER_ROLE, admin);
        _grantRole(UPGRADER_ROLE, admin);
        _grantRole(PAUSER_ROLE, admin);
        _feeWallet = initialFeeWallet;
        _feeTiers.push(FeeTier({maxAmount: 100e6, feeBasisPoints: 100}));
        _feeTiers.push(FeeTier({maxAmount: 500e6, feeBasisPoints: 50}));
        _feeTiers.push(FeeTier({maxAmount: 1_000e6, feeBasisPoints: 25}));
        _feeTiers.push(FeeTier({maxAmount: 10_000e6, feeBasisPoints: 10}));
        _feeTiers.push(FeeTier({maxAmount: 100_000e6, feeBasisPoints: 5}));
        _feeTiers.push(FeeTier({maxAmount: type(uint256).max, feeBasisPoints: 1}));
        emit FeeTiersUpdated(admin, 6);
        if (initialFeeWallet != address(0)) {
            emit FeeWalletUpdated(address(0), initialFeeWallet, admin);
        }
    }

    function calculateFee(uint256 amount) external view override whenNotPaused returns (uint256 feeAmount, uint16 feeBasisPoints) {
        if (amount == 0) revert ZeroAmount();
        uint256 tierCount = _feeTiers.length;
        for (uint256 i = 0; i < tierCount;) {
            if (amount <= _feeTiers[i].maxAmount) {
                feeBasisPoints = _feeTiers[i].feeBasisPoints;
                feeAmount = (amount * feeBasisPoints) / MAX_BASIS_POINTS;
                return (feeAmount, feeBasisPoints);
            }
            unchecked { ++i; }
        }
        feeBasisPoints = _feeTiers[tierCount - 1].feeBasisPoints;
        feeAmount = (amount * feeBasisPoints) / MAX_BASIS_POINTS;
    }

    function setFeeWallet(address newFeeWallet) external onlyRole(FEE_MANAGER_ROLE) {
        if (newFeeWallet == address(0)) revert ZeroAddress();
        address oldWallet = _feeWallet;
        _feeWallet = newFeeWallet;
        emit FeeWalletUpdated(oldWallet, newFeeWallet, msg.sender);
    }

    function setFeeTiers(FeeTier[] calldata newTiers) external onlyRole(FEE_MANAGER_ROLE) {
        if (newTiers.length == 0) revert InvalidFeeTiers();
        uint256 previousMax = 0;
        for (uint256 i = 0; i < newTiers.length;) {
            if (newTiers[i].feeBasisPoints > MAX_BASIS_POINTS) revert InvalidBasisPoints(newTiers[i].feeBasisPoints);
            if (i > 0 && newTiers[i].maxAmount <= previousMax) revert TiersNotAscending();
            previousMax = newTiers[i].maxAmount;
            unchecked { ++i; }
        }
        delete _feeTiers;
        for (uint256 i = 0; i < newTiers.length;) {
            _feeTiers.push(newTiers[i]);
            unchecked { ++i; }
        }
        emit FeeTiersUpdated(msg.sender, newTiers.length);
    }

    function feeWallet() external view override returns (address) { return _feeWallet; }
    function getFeeTiers() external view override returns (FeeTier[] memory) { return _feeTiers; }
    function feeTierCount() external view returns (uint256) { return _feeTiers.length; }
    function pause() external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
