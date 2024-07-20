// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "src/AbiEncoder.sol";

contract AbiEncoderTest is Test {


    function setUp() public {
        abiEncoder = new encoder();
    }

    function testAbiEncoder() public {}
}
