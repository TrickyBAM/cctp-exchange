// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {AccessControlManager} from "../src/AccessControlManager.sol";

contract AccessControlManagerTest is Test {
    AccessControlManager public acm;
    address public admin = makeAddr("admin");
    address public operator = makeAddr("operator");
    address public unauthorized = makeAddr("unauthorized");

    function setUp() public {
        AccessControlManager impl = new AccessControlManager();
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), abi.encodeCall(AccessControlManager.initialize, (admin)));
        acm = AccessControlManager(address(proxy));
    }

    function test_AdminHasAllRoles() public view {
        assertTrue(acm.hasRole(acm.DEFAULT_ADMIN_ROLE(), admin));
        assertTrue(acm.hasRole(acm.OPERATOR_ROLE(), admin));
        assertTrue(acm.hasRole(acm.FEE_MANAGER_ROLE(), admin));
        assertTrue(acm.hasRole(acm.TREASURY_ROLE(), admin));
        assertTrue(acm.hasRole(acm.UPGRADER_ROLE(), admin));
        assertTrue(acm.hasRole(acm.PAUSER_ROLE(), admin));
    }

    function test_GrantRole() public {
        bytes32 role = acm.OPERATOR_ROLE();
        vm.prank(admin);
        acm.grantRole(role, operator);
        assertTrue(acm.hasRole(role, operator));
    }

    function test_RevertGrantRole_Unauthorized() public {
        bytes32 role = acm.OPERATOR_ROLE();
        vm.expectRevert();
        vm.prank(unauthorized);
        acm.grantRole(role, unauthorized);
    }
}
