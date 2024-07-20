// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract Ownable {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
}
