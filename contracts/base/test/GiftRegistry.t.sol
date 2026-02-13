// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/GiftRegistry.sol";

contract GiftRegistryTest is Test {
    GiftRegistry public c;
    
    function setUp() public {
        c = new GiftRegistry();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
