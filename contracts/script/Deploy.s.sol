// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {FeeManager} from "../src/FeeManager.sol";
import {Treasury} from "../src/Treasury.sol";
import {CCTPBridgeOrchestrator} from "../src/CCTPBridgeOrchestrator.sol";
import {AccessControlManager} from "../src/AccessControlManager.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address admin = vm.envAddress("ADMIN_ADDRESS");
        address usdcToken = vm.envAddress("USDC_TOKEN_ADDRESS");
        address feeWallet = vm.envOr("FEE_WALLET_ADDRESS", address(0));
        vm.startBroadcast(deployerPrivateKey);
        AccessControlManager acmImpl = new AccessControlManager();
        ERC1967Proxy acmProxy = new ERC1967Proxy(address(acmImpl), abi.encodeCall(AccessControlManager.initialize, (admin)));
        console2.log("AccessControlManager:", address(acmProxy));
        FeeManager fmImpl = new FeeManager();
        ERC1967Proxy fmProxy = new ERC1967Proxy(address(fmImpl), abi.encodeCall(FeeManager.initialize, (admin, feeWallet)));
        console2.log("FeeManager:", address(fmProxy));
        Treasury treasuryImpl = new Treasury();
        ERC1967Proxy treasuryProxy = new ERC1967Proxy(address(treasuryImpl), abi.encodeCall(Treasury.initialize, (admin)));
        console2.log("Treasury:", address(treasuryProxy));
        CCTPBridgeOrchestrator orchImpl = new CCTPBridgeOrchestrator();
        ERC1967Proxy orchProxy = new ERC1967Proxy(address(orchImpl), abi.encodeCall(CCTPBridgeOrchestrator.initialize, (admin, address(fmProxy), address(treasuryProxy), usdcToken)));
        console2.log("BridgeOrchestrator:", address(orchProxy));
        Treasury(address(treasuryProxy)).grantRole(keccak256("DEPOSITOR_ROLE"), address(orchProxy));
        vm.stopBroadcast();
    }
}
