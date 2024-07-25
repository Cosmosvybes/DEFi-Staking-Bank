// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import "../src/Bank.sol";
import "../src/DBCoin.sol";
import "../src/DBRC.sol";

contract BankScipt is Script {
    DBcoin coin;
    DBRC reward;
    DecentralBank bank;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        coin = new DBcoin();
        reward = new DBRC();
        bank = new DecentralBank(coin, reward);
        reward.transfer(address(bank), 100000000000000000000);
        coin.transfer(address(bank), 1000000000000000000000000);
        vm.stopBroadcast();
    }
}
