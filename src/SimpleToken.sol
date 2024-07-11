// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26 <0.9.1;

library safeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(a > b);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / b == a);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(c * b + (a % b) == a);
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(
        address _address
    ) external view returns (uint256 balance);
    function approve(address _address, uint256 _amount) external returns (bool);
    function allowance(address _address) external returns (uint256 remaining);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(
        address _to,
        address _spender,
        uint256 _amount
    ) external returns (bool);
    event Approval(address indexed _owner, address _spender, uint256 _amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
}

contract _ownable {
    address owner;

    constructor(address _owner) {
        owner = _owner;
    }
    modifier _onlyOwner() {
        require(msg.sender == owner, "Access denied");
        _;
    }

    function _changeOwner(
        address _newOwner
    ) external _onlyOwner returns (bool) {
        require(_newOwner != address(0), "User address different address");
        owner = _newOwner;
        return true;
    }
}

contract SimpleToken is ERC20, _ownable {
    using safeMath for uint256;
    string name;
    string symbol;
    uint8 decimals;
    uint256 _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    constructor(
        address _address,
        string memory _name,
        string memory _symbol,
        uint8 _decimal
    ) _ownable(payable(_address)) {
        name = _name;
        symbol = _symbol;
        decimals = _decimal;
        _totalSupply = 1000001000000;
    }

    function getName() public view returns (string memory) {
        return name;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _address) public view returns (uint256 balance) {
        return balances[_address];
    }
    function allowance(
        address _spender
    ) public view _onlyOwner returns (uint256 remaining) {
        return allowed[owner][_spender];
    }

    modifier _hasEnoughToken(uint256 _amount) {
        require(balances[msg.sender] > _amount, "Insufficient balance");
        _;
    }
    error InvalidAddress();

    function transfer(
        address _to,
        uint256 _amount
    ) public _hasEnoughToken(_amount) returns (bool) {
        if (_to == address(msg.sender)) {
            revert InvalidAddress();
        }
        balances[msg.sender].sub(_amount);
        balances[_to].add(_amount);
        emit Transfer(owner, _to, _amount);
        return true;
    }

    function transferFrom(
        address _to,
        address _spender,
        uint256 _amount
    ) public returns (bool) {
        require(allowed[owner][_spender] > _amount, "Spending limit exceeded");
        balances[owner].sub(_amount);
        balances[_to].add(_amount);
        allowed[owner][_spender].sub(_amount);
        emit Transfer(owner, _to, _amount);
        return true;
    }
    function approve(address _spender, uint256 _amount) public returns (bool) {
        allowed[owner][_spender].sub(_amount);
        emit Approval(owner, _spender, _amount);
        return true;
    }
}
