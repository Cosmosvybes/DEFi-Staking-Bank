// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
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
        address _spender,
        address _to,
        uint256 _amount
    ) external returns (bool);
    event Approval(address indexed _owner, address _spender, uint256 _amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
}

contract _ownable {
    address payable internal owner;
    bool isLocked;
    constructor(address payable _owner) {
        owner = _owner;
    }
    modifier _onlyOwner() {
        require(msg.sender == owner, "Access denied");
        _;
    }

    function _changeOwner(
        address payable _newOwner
    ) public _onlyOwner returns (bool) {
        require(_newOwner != address(owner), "Use address different address");
        owner = _newOwner;
        return true;
    }
    modifier isNotLocked() {
        require(isLocked == false, "Token is locked");
        _;
    }
    function lock() internal _onlyOwner returns (bool) {
        return isLocked = true;
    }
    function unLock() public _onlyOwner returns (bool) {
        return isLocked = false;
    }
}

contract SimpleToken is ERC20, _ownable {
    using safeMath for uint256;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) internal balances;
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
        totalSupply = 10000000 * 10 ** decimals;
        balances[owner] = totalSupply;
    }

    function _getOwner() public view returns (address _owner) {
        return owner;
    }

    function getName() public view returns (string memory) {
        return name;
    }
    function getSymbol() public view returns (string memory) {
        return symbol;
    }
    function _totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _address) public view returns (uint256 balance) {
        return balances[_address];
    }
    function allowance(
        address _spender
    ) public view returns (uint256 remaining) {
        return allowed[owner][_spender];
    }

    modifier _hasEnoughToken(uint256 _amount) {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        _;
    }
    error InvalidAddress();

    function transfer(
        address _to,
        uint256 _amount
    ) public _hasEnoughToken(_amount) returns (bool) {
        if (_to == msg.sender) {
            revert InvalidAddress();
        }
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(owner, _to, _amount);
        return true;
    }

    function transferFrom(
        address _spender,
        address _to,
        uint256 _amount
    ) public returns (bool) {
        require(allowed[owner][_spender] >= _amount, "Spending limit exceeded");
        balances[owner] = balances[owner].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        allowed[owner][_spender] = allowed[owner][_spender].sub(_amount);
        emit Transfer(owner, _to, _amount);
        return true;
    }
    function approve(
        address _spender,
        uint256 _amount
    ) public _onlyOwner returns (bool) {
        allowed[owner][_spender] = allowed[owner][_spender].add(_amount);
        emit Approval(owner, _spender, _amount);
        return true;
    }
}

contract Escrow is _ownable, SimpleToken {
    using safeMath for uint256;

    constructor(
        address _address,
        string memory _name,
        string memory _symbol,
        uint8 _decimal
    ) SimpleToken(payable(_address), _name, _symbol, _decimal) {
        lock();
    }

    function switchOwner(
        address payable _newOwner
    ) public _onlyOwner returns (bool success) {
        balances[_newOwner] = balances[_newOwner].add(balances[owner]);
        balances[owner] = 0;
        _changeOwner(_newOwner);
        return true;
    }

    function _tokenQoutes() internal returns (uint256) {
        uint8 _oneTokenBits = 20;
        uint256 _toTokens = 10 ** decimals;
        uint256 _tokenAmount = msg.value.div(_oneTokenBits).div(_toTokens);
        return _tokenAmount;
    }

    function _purchaseToken(
        address _recepient
    )
        public
        payable
        isNotLocked
        returns (bool truthyFalsy, bytes memory response)
    {
        require(msg.value >= 0.005 ether, "Low ether balance");
        uint256 _tokens = _tokenQoutes();
        transferFrom(msg.sender, _recepient, _tokens);
        (bool success, bytes memory data) = owner.call{value: msg.value}("");
        if (success) {
            return (true, data);
        }
    }

    receive() external payable {}
}
