// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

//??===============================================================================================================================
//??===============================================================================================================================
//??===============================================================================================================================


import "./Ownable.sol";
interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

//testing how abiEncode works !!!
contract Token is IERC20, Ownable {
    mapping(address => uint256) balances;
    string public name;
    uint8 public decimals;
    string public symbol;
    uint256 totatSupply;

    constructor() Ownable() {
        decimals = 10;
        totatSupply = 1000000 * 1 * (10 ** decimals);
        balances[owner] = totatSupply;
    }

    function transfer(address _address, uint256 _amount) public returns (bool) {
        balances[owner] -= _amount;
        balances[_address] += _amount;
        return true;
    }
}


