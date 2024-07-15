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
            payable(0x42637396821B84A786382aF4706873fb78FAc879),
            "FLICKS TOKEN",
            "FLT",
            10
        );
        vm.stopBroadcast();
    }
}
