// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Ledger {
    string public name;
    address private owner;
    address public _this;

    constructor() {
        owner = msg.sender;
        name = "Ledger Acccount";
        _this = address(this);
    }

    struct User {
        address user;
        bytes32 walletAddress;
    }
    mapping(address => mapping(bytes32 => User)) public users;
    mapping(address => bool) hasWalletAddress;

    //Account Abstraction
    function onboard() public returns (address) {
        bytes32 _id = keccak256(abi.encodePacked(msg.sender));
        users[_this][_id] = User(msg.sender, _id);
        hasWalletAddress[msg.sender] = true;
        return getUser(_id);
    }

    function getUser(bytes32 _id) public view returns (address user) {
        address _user = users[_this][_id].user;
        return _user;
    }

    function ERC20symbol(
        address _contract
    ) public view returns (string memory symbol) {
        (bool ok, bytes memory data) = _contract.staticcall(
            abi.encodeWithSignature("getSymbol()")
        );
        require(ok, "unable to get token symbol");
        string memory _tokenSymbol = abi.decode(data, (string));
        return _tokenSymbol;
    }

    function tokenSaleAllowance(
        address _contract
    ) public view returns (uint256 remianing) {
        (bool success, bytes memory data) = _contract.staticcall(
            abi.encodeWithSignature("allowance(address)", _this)
        );
        require(success, "unable to get sales allowance");
        uint256 _allowance = abi.decode(data, (uint256));
        return _allowance;
    }

    modifier isAllowed() {
        require(hasWalletAddress[msg.sender], "!Auth");
        _;
    }
    // /**
    //  *
    //  * @param _walletAddress onboarded user abstracted account address
    //  * @param contract_ token contract address
    //  * @return balance_ new token balance of the user after purchase
    //  * @return success_ successful trade
    //  * @dev Escrow mechanism for token purchase.
    //  */

    function buy(
        address contract_,
        bytes32 _walletAddress
    ) public payable returns (uint256) {
        (bool success, bytes memory transaction_) = contract_.delegatecall(
            abi.encodeWithSignature(
                "transferFrom(address,address)",
                _this,
                users[_this][_walletAddress].user
            )
        );
        uint256 _amount = abi.decode(transaction_, (uint256));
        return _amount;


        // require(success, "Token purchase failed");
        // bool fullfilled = abi.decode(transaction_, (bool));
        // return fullfilled;

        // (bool ok, bytes memory data) = contract_.delegatecall(
        //     abi.encodeWithSignature(
        //         "balanceOf(adddress)",
        //         users[_this][_walletAddress].user
        //     )
        // );
        // require(ok, "! Balance check failed");
        // uint256 _balance = abi.decode(data, (uint256));
        // return (_balance, fullfilled);
    }
}
