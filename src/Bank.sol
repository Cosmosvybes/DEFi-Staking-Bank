// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SAFE MATH
////////////////////////////////////////////////////////////////////////////////////////////////////////////
import "../src/SafeMath/SafeMath.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BANK CURRENCIES
////////////////////////////////////////////////////////////////////////////////////////////////////////////

import "./DBCoin.sol";
import "./DBRC.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Decentral Bank
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
contract DecentralBank {
    using SafeMath for uint256;
    string public _name;
    string public _symbol;
    DBcoin coin;
    DBRC reward;
    address private bank;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Constrctor
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    constructor(DBcoin coin_, DBRC reward_) {
        _name = "DECENTRAL BANK ULTD";
        _symbol = "DCBU";
        coin = coin_;
        reward = reward_;
        bank = msg.sender;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // BANK Records Variables
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;
    address[] public stakersAccount;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // FUNCTIONS
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    function buyCoin() public payable returns (bool, bytes memory _data) {
        require(msg.value >= 0.005 ether, "Insufficient ether"); // Purchasing price is starts from 0.005 ether
        uint256 coins_ = msg.value.div(20).div(10 ** 10); // calculate the coins in respect to the buyers power;
        (bool success, bytes memory data) = address(this).call{ // accept payment from the customer
            value: msg.value
        }("");
        require(success, "payment failed");
        coin.transfer(msg.sender, coins_);
        return (success, data);
    }

    function depositFunds(uint256 _amount) public returns (bool) {
        require(_amount > 0, "Zero funds");
        bool txSuccess = coin.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add(_amount);
        if (!hasStaked[msg.sender]) {
            stakersAccount.push(msg.sender);
        }
        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
        require(txSuccess);
        return true;
    }

    function unstakeFunds(uint256 _amount) public returns (bool) {
        require(
            stakingBalance[msg.sender] > 0 && //withdraw funds
                _amount <= stakingBalance[msg.sender],
            "Insufficiency"
        );
        bool success = coin.transfer(msg.sender, _amount);
        require(success, "withdrawal failed");
        stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(_amount);
        if (stakingBalance[msg.sender] == 0) {
            isStaking[msg.sender] = false;
        }
        return hasStaked[msg.sender];
    }

    modifier isFromDecentralBank() {
        require(msg.sender == bank, "Permission Denied");
        _;
    }

    function distributeStakingRewards()
        public
        // distribute tokens to the stakers
        isFromDecentralBank
        returns (bool success)
    {
        for (uint256 i = 0; i < stakersAccount.length; ) {
            address staker = stakersAccount[i];
            if (stakingBalance[staker] == 0 && stakingBalance[staker] < 50) {
                continue;
            }
            uint256 rewards = stakingBalance[staker].div(50);
            reward.transfer(staker, rewards);
            unchecked {
                ++i;
            }
        }
        return true;
    }

    function convertRewards() internal view returns (uint256) {
        uint256 _rewardsFromDbrc = reward.balanceOf(msg.sender);
        uint256 _toDBCoin = _rewardsFromDbrc.mul(5);
        return _toDBCoin;
    }

    function withdrawRewards() public returns (bool) {
        require(reward.balanceOf(msg.sender) > 0, "Low rewards balance"); // requires that the reward balance is 50 and above;
        uint256 _rewards = convertRewards(); //  convert rewards to coin;
        reward.transferFrom(
            msg.sender,
            address(this),
            reward.balanceOf(msg.sender)
        ); //send reward token to bank;
        coin.transfer(msg.sender, _rewards);
        return true; // bank transfer to the customer;
    }

    fallback() external payable {}
    receive() external payable {}
}
