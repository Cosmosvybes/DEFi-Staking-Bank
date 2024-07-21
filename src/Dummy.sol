// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

//??===============================================================================================================================
//??===============================================================================================================================

library SafeMath {
    function div(uint256 a, uint256 b) external returns (uint256) {
        require(b > 0); // avoid division of by zero.
        uint256 c = a / b;
        require((c * b) + (a % b) == a);
        return c;
    }

    function mul(uint256 a, uint256 b) external returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        return c;
    }
}

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
    function allowance(
        address _spender
    ) external view returns (uint256 remaining);

    function approve(address _spender, uint _amount) external returns (bool);
    function transferFrom(
        address _from,
        address _to
    ) external payable returns (uint256);

    event Withdrawal(
        address indexed _address,
        uint256 timestamp,
        uint256 _amount
    );
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );
}

contract Dummy is IERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    string public name;
    uint8 public decimals;
    string public symbol;
    uint256 totatSupply;
    address payable owner;
    uint256 count;

    constructor(address payable _owner) {
        owner = _owner;
        decimals = 10;
        totatSupply = 1000000 * 1 * (10 ** decimals);
        balances[owner] = totatSupply;
        count = 0;
        name = "DUMMY TOKEN";
        symbol = "DMT";
    }

    function getSymbol() public view returns (string memory) {
        return symbol;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function approve(
        address _spender,
        uint256 _amount
    ) public onlyOwner returns (bool) {
        allowed[owner][_spender] += _amount;
        emit Approval(owner, _spender, _amount);
        return true;
    }

    function allowance(
        address _spender
    ) public view returns (uint256 remaining) {
        return allowed[owner][_spender];
    }

    function transfer(address _address, uint256 _amount) public returns (bool) {
        balances[owner] -= _amount;
        balances[_address] += _amount;
        return true;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "!Auth");
        _;
    }
    function withdraw(
        address _adddres
    ) public onlyOwner returns (bytes memory data_) {
        require(address(this).balance > 1 ether, "Balance not ripe");
        (bool success, bytes memory data) = _adddres.call{
            value: address(this).balance
        }("");
        require(success, "Withdrawal failed!");
        emit Withdrawal(_adddres, block.timestamp, address(this).balance);
        return (data);
    }

    function transferFrom(
        address _spender,
        address _to
    ) public payable returns (uint256) {
        require(msg.value >= 0.0005 ether, "Low ether balance!");
        uint256 portion = msg.value.div(20).div((10 ** decimals));
        return portion;
        // require(allowed[owner][_spender] >= portion, "Trade Limits >>");
        // balances[owner] -= portion;
        // balances[_to] += portion;
        // address(this).call{value: msg.value}("");
        // allowed[owner][_spender] -= portion;
        // emit Transfer(owner, _to, portion);
        // return true;
    }
}
