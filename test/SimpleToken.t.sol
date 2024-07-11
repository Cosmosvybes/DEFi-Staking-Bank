// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Test, console} from "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract simpleTokenTest is SimpleToken {
    SimpleToken simpletoken;
    function setUp() {
        simpletoken = new SimpleToken(
            payable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            "SIMPLE TOKEN",
            "SMTK",
            10
        );
    }

    function testGetName() {
        string _name = simpletoken.getName();
        assertEq(_name, "SIMPLE TOKEN");
    }
}
