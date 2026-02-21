// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20Mock} from "./mocks/ERC20Mock.sol";
import {FeeManager} from "../src/FeeManager.sol";
import {Treasury} from "../src/Treasury.sol";
import {CCTPBridgeOrchestrator} from "../src/CCTPBridgeOrchestrator.sol";

contract CCTPBridgeOrchestratorTest is Test {
    CCTPBridgeOrchestrator public orchestrator;
    FeeManager public feeManager;
    Treasury public treasury;
    ERC20Mock public usdc;
    address public admin = makeAddr("admin");
    address public feeWallet = makeAddr("feeWallet");
    address public user = makeAddr("user");

    function setUp() public {
        usdc = new ERC20Mock("USDC", "USDC", 6);
        FeeManager fmImpl = new FeeManager();
        ERC1967Proxy fmProxy = new ERC1967Proxy(address(fmImpl), abi.encodeCall(FeeManager.initialize, (admin, feeWallet)));
        feeManager = FeeManager(address(fmProxy));
        Treasury tImpl = new Treasury();
        ERC1967Proxy tProxy = new ERC1967Proxy(address(tImpl), abi.encodeCall(Treasury.initialize, (admin)));
        treasury = Treasury(address(tProxy));
        CCTPBridgeOrchestrator oImpl = new CCTPBridgeOrchestrator();
        ERC1967Proxy oProxy = new ERC1967Proxy(address(oImpl), abi.encodeCall(CCTPBridgeOrchestrator.initialize, (admin, address(fmProxy), address(tProxy), address(usdc))));
        orchestrator = CCTPBridgeOrchestrator(address(oProxy));
        vm.prank(admin);
        treasury.grantRole(keccak256("DEPOSITOR_ROLE"), address(orchestrator));
        usdc.mint(user, 10_000e6);
    }

    function test_CollectFee_Tier1() public {
        vm.startPrank(user);
        usdc.approve(address(orchestrator), type(uint256).max);
        orchestrator.collectFee(keccak256("tx-1"), 50e6, 0);
        vm.stopPrank();
        assertEq(usdc.balanceOf(feeWallet), 500_000);
        assertEq(orchestrator.totalTransfers(), 1);
    }

    function test_RevertCollectFee_Replay() public {
        vm.startPrank(user);
        usdc.approve(address(orchestrator), type(uint256).max);
        orchestrator.collectFee(keccak256("tx-1"), 50e6, 0);
        vm.expectRevert(abi.encodeWithSelector(CCTPBridgeOrchestrator.TransferAlreadyProcessed.selector, keccak256("tx-1")));
        orchestrator.collectFee(keccak256("tx-1"), 50e6, 0);
        vm.stopPrank();
    }

    function test_PreviewFee() public view {
        (uint256 feeAmount, uint256 netAmount, uint16 bps) = orchestrator.previewFee(1_000e6);
        assertEq(bps, 25);
        assertEq(feeAmount, 2_500_000);
        assertEq(netAmount, 997_500_000);
    }
}
