// SPDX-License-Identifier: MIT

pragma solidity >=0.8.26;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// SAFE MATH IMPORT
///////////////////////////////////////////////////////////////////////////////////////////////////////////
import "../src/SafeMath/SafeMath.sol";
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// COIN CONTRACT
///////////////////////////////////////////////////////////////////////////////////////////////////////////

contract DBRC {
    using SafeMath for uint256;
    event Transfer(address _from, address _to, uint256 _amount);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    // COIN METADATA
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    string public name;
    string public symbol;
    uint8 decimals = 18;
    uint256 public _totalSupply = 100000000000000000000;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  VARIABLES
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    constructor() {
        name = "Decentral Bank Reward Coin";
        symbol = "DBRC";
        balances[msg.sender] = _totalSupply;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    // FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    function _mint(address _to, uint256 amount_) public {
        require(_to != address(0), "!Address(0)");
        balances[_to] = balances[_to].add(amount_);
        _totalSupply = _totalSupply + amount_;
        emit Transfer(msg.sender, _to, amount_);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function approve(
        address _spender,
        uint256 _amount
    ) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[msg.sender], "Insuff. Balance");
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        return true;
    }
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool) {
        require(_amount <= balances[_from], "Insufficient. Bal");
        require(_amount <= allowed[_from][msg.sender], "Spend Limit");
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }
    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
}
