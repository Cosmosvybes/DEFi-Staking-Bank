// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console} from "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract simpleTokenTest is Test {
    SimpleToken simpletoken;
    Escrow escrow;
    address owner;
    function setUp() public {
        owner = payable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.deal(owner, 0 ether);
        vm.prank(owner);
        escrow = new Escrow(owner, "SIMPLE TOKEN", "SPTK", 10);
    }

    function testGetName() public view {
        string memory _name = escrow.getName();
        assertEq(_name, "SIMPLE TOKEN");
    }
    function testTotalSuply() public view {
        uint256 _tottalSuppplyValue = escrow.totalSupply();
        assertEq(_tottalSuppplyValue, 1000001000000);
        address _owner = escrow._getOwner();
        assertEq(
            escrow._getOwner(),
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
        );
        assertEq(escrow.balanceOf(_owner), 1000001000000);
    }

    function test_ChangeOwner() public {
        vm.prank(address(owner));
        escrow.switchOwner(payable(0x70997970C51812dc3A010C7d01b50e0d17dc79C8));
        assertEq(
            escrow.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            1000001000000
        );
        assertEq(escrow.balanceOf(owner), 0);
    }

    function testTransfer() public {
        vm.prank(owner);
        escrow.transfer(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000);
        assertEq(
            escrow.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            1000
        );
        assertEq(escrow.balanceOf(owner), 1000000999000);
    }

    function testApproval() public {
        vm.prank(owner);
        escrow.approve(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720, 10000000);
        assertEq(
            escrow.allowance(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720),
            10000000
        );
    }

    function test_ExchangeWithEther() public {
        vm.prank(owner);
        escrow.unLock();
        vm.prank(owner);
        escrow.approve(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 200000);
        vm.deal(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 0.005 ether);
        vm.prank(address(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC));
        escrow._purchaseToken{
            value: address(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC).balance
        }(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);

        assertEq(
            escrow.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            25000
        );
        assertEq(escrow.balanceOf(owner), 1000000975000);
        assertEq(
            escrow.allowance(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
            175000
        );
        assertEq(owner.balance, 0.005 ether);
    }
}
