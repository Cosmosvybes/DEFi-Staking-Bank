// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console} from "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract simpleTokenTest is Test {
    SimpleToken simpletoken;
    Escrow escrow;
    address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    function setUp() public {
        vm.deal(owner, 0 ether);
        vm.prank(owner);
        escrow = new Escrow(payable(owner), "SIMPLE TOKEN", "SPTK", 10);
    }

    function testGetName() public view {
        string memory _name = escrow.getName();
        assertEq(_name, "SIMPLE TOKEN");
    }
    function testTotalSuply() public view {
        uint256 _totalSuppplyValue = escrow.totalSupply();
        assertEq(_totalSuppplyValue, 1000001000000);
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

    function test_Faucet() public {
        escrow.recieveTokenDrop(owner);

        uint256 _time = escrow.getTokenDisbursedTimestamp(
            0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f
        );
        escrow.recieveTokenDrop(0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f);
        // assertEq(_time, 1721205299);
        // escrow.recieveTokenDrop(0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f);
        // uint256 _time_ = escrow.getTokenDisbursedTimestamp(
        //     0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f
        // );
    }
}
