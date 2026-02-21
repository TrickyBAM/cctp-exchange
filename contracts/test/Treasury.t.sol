// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20Mock} from "./mocks/ERC20Mock.sol";
import {Treasury} from "../src/Treasury.sol";
import {ITreasury} from "../src/interfaces/ITreasury.sol";

contract TreasuryTest is Test {
    Treasury public treasury;
    ERC20Mock public usdc;
    address public admin = makeAddr("admin");
    address public depositor = makeAddr("depositor");
    address public recipient = makeAddr("recipient");

    function setUp() public {
        usdc = new ERC20Mock("USDC", "USDC", 6);
        Treasury impl = new Treasury();
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), abi.encodeCall(Treasury.initialize, (admin)));
        treasury = Treasury(address(proxy));
        vm.prank(admin);
        treasury.grantRole(keccak256("DEPOSITOR_ROLE"), depositor);
        usdc.mint(depositor, 1_000_000e6);
    }

    function test_DepositFee() public {
        vm.startPrank(depositor);
        usdc.approve(address(treasury), 100e6);
        treasury.depositFee(address(usdc), 100e6, keccak256("t1"));
        vm.stopPrank();
        assertEq(treasury.getBalance(address(usdc)), 100e6);
    }

    function test_Withdraw() public {
        vm.startPrank(depositor);
        usdc.approve(address(treasury), 100e6);
        treasury.depositFee(address(usdc), 100e6, keccak256("t1"));
        vm.stopPrank();
        vm.prank(admin);
        treasury.withdraw(address(usdc), recipient, 100e6);
        assertEq(usdc.balanceOf(recipient), 100e6);
    }

    function test_EmergencyWithdraw() public {
        vm.startPrank(depositor);
        usdc.approve(address(treasury), 100e6);
        treasury.depositFee(address(usdc), 100e6, keccak256("t1"));
        vm.stopPrank();
        vm.prank(admin);
        treasury.pause();
        vm.prank(admin);
        treasury.emergencyWithdraw(address(usdc), recipient, 100e6);
        assertEq(usdc.balanceOf(recipient), 100e6);
    }
}
