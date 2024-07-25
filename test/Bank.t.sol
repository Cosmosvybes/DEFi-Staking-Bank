// SPDX-License-Identifier: MIT
import {Test, console} from "forge-std/Test.sol";
import "../src/Bank.sol";
import "../src/DBCoin.sol";
import "../src/DBRC.sol";

pragma solidity 0.8.26;

contract testBank is Test {
    DecentralBank bank;
    DBcoin coin;
    DBRC reward;

    function setUp() public {
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        coin = new DBcoin();
        reward = new DBRC();
        bank = new DecentralBank(coin, reward);
        reward.transfer(address(bank), 100000000000000000000);
        coin.transfer(address(bank), 1000000000000000000000000);
        vm.stopPrank();
    }

    function test_checkBalance() public view {
        assertEq(coin.balanceOf(address(bank)), 1000000000000000000000000);
    }

    function test_BankingProcess() public {
        vm.deal(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 0.008 ether);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);

        (bool success, bytes memory _data) = bank.buyCoin{
            value: address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266).balance
        }();
        assertEq(
            coin.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            40000
        );
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        coin.approve(address(bank), 400);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        bank.depositFunds(400);
        assertEq(
            coin.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            39600
        );
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        bank.distributeStakingRewards();

        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        reward.approve(address(bank), 8);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        bank.withdrawRewards();
    }
}
