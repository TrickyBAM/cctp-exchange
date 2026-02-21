// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {FeeManager} from "../src/FeeManager.sol";
import {IFeeManager} from "../src/interfaces/IFeeManager.sol";

contract FeeManagerTest is Test {
    FeeManager public feeManager;
    address public admin = makeAddr("admin");
    address public feeWallet = makeAddr("feeWallet");
    address public unauthorized = makeAddr("unauthorized");

    function setUp() public {
        FeeManager impl = new FeeManager();
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), abi.encodeCall(FeeManager.initialize, (admin, feeWallet)));
        feeManager = FeeManager(address(proxy));
    }

    function test_Initialize() public view {
        assertEq(feeManager.feeWallet(), feeWallet);
        assertEq(feeManager.feeTierCount(), 6);
        assertTrue(feeManager.hasRole(feeManager.DEFAULT_ADMIN_ROLE(), admin));
    }

    function test_FeeTier1_Under100() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(50e6);
        assertEq(fee, 500_000);
        assertEq(bps, 100);
    }

    function test_FeeTier2_250() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(250e6);
        assertEq(fee, 1_250_000);
        assertEq(bps, 50);
    }

    function test_FeeTier3_750() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(750e6);
        assertEq(fee, 1_875_000);
        assertEq(bps, 25);
    }

    function test_FeeTier4_5000() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(5_000e6);
        assertEq(fee, 5_000_000);
        assertEq(bps, 10);
    }

    function test_FeeTier5_50000() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(50_000e6);
        assertEq(fee, 25_000_000);
        assertEq(bps, 5);
    }

    function test_FeeTier6_500000() public view {
        (uint256 fee, uint16 bps) = feeManager.calculateFee(500_000e6);
        assertEq(fee, 50_000_000);
        assertEq(bps, 1);
    }

    function test_SetFeeWallet() public {
        address newWallet = makeAddr("newWallet");
        vm.prank(admin);
        feeManager.setFeeWallet(newWallet);
        assertEq(feeManager.feeWallet(), newWallet);
    }

    function test_RevertSetFeeWallet_Unauthorized() public {
        vm.prank(unauthorized);
        vm.expectRevert();
        feeManager.setFeeWallet(makeAddr("newWallet"));
    }

    function test_RevertFeeCalculation_ZeroAmount() public {
        vm.expectRevert(IFeeManager.ZeroAmount.selector);
        feeManager.calculateFee(0);
    }

    function test_Pause() public {
        vm.prank(admin);
        feeManager.pause();
        vm.expectRevert();
        feeManager.calculateFee(100e6);
    }
}
