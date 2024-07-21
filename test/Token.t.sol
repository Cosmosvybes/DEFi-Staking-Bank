// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Test, console} from "forge-std/Test.sol";

import "../src/Dummy.sol";
import "../src/Ledger.sol";

contract TokenTest is Test {
    Dummy token;
    Ledger ledger;
    address tokenAddress;
    address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        token = new Dummy(payable(owner));
        ledger = new Ledger();
        tokenAddress = address(token);
    }

    function test_getSymbol() public view {
        string memory _symbol = ledger.ERC20symbol(tokenAddress);
        assertEq(_symbol, "DMT");
    }

    function test_Buy() public {
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        address user = ledger.onboard();
        // vm.prank(owner);
        // token.approve(address(ledger), 10000000);
        vm.deal(user, 0.005 ether);
        // vm.prank(user);
        uint256 _portion = ledger.buy{value: user.balance}(
            tokenAddress,
            keccak256(abi.encodePacked(user))
        );
        assertEq(_portion, 25000);
        // assertEq(token.allowance(address(ledger)), 10000);
    }

    function test_TransferFrom() public {
        // vm.prank(owner);
        // token.approve(address(ledger), 10000000);
        uint256 _amount = token.transferFrom{value: 0.005 ether}(
            address(ledger),
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        assertEq(_amount, 25000);
        // assertEq(token.allowance(address(ledger)), 9990000);
        // assertEq(tokenAddress.balance, 0.0005 ether);
    }

    function test_getSalesAllowance() public {
        vm.prank(owner);
        token.approve(address(ledger), 1000);
        uint256 _spendAllowance = ledger.tokenSaleAllowance(tokenAddress);
        assertEq(_spendAllowance, 1000);
    }

    function testOnboard() public {
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        address user = ledger.onboard();
        assertEq(user, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    }
}
