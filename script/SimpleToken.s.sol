// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import "../src/SimpleToken.sol";

contract simpleTokenScript is Script {
    Escrow escrow;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        escrow = new Escrow(
            payable(0xb2Dc9f4b66c5C3EFE479e2585d199442C8066ab3),
            "MILLS TOKEN",
            "MLT",
            10
        );
        vm.stopBroadcast();
    }
}
