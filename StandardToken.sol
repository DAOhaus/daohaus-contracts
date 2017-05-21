/*
This implements ONLY the standard functions and NOTHING else.
For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.

If you deploy this, you won't have anything useful.

Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
.*/

pragma solidity ^0.4.4;

import "./Token.sol";

contract StandardToken is Token {
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply = 365;
    uint256 public deadline;
    uint256 public finalAmount;
    address public creator;
    address[] public pledgeAccounts;
    bool public called;
    
    function StandardToken() {
        deadline = now + 2592000; // one month
        creator = msg.sender;
    }
    
    modifier onlyAfterDeadline(){ if(now > deadline) _; }
    modifier onlyBeforeDistribution(){ if(!called) _; }
    
    function distributeTokens() onlyAfterDeadline onlyBeforeDistribution{
      called = true;
      for (uint i = 0; i < pledgeAccounts.length; i++) {
        uint ownershipPercentage = balances[pledgeAccounts[i]] / this.balance;
        uint totalTokens = ownershipPercentage * totalSupply;
        transfer(balances[pledgeAccounts[i]], totalTokens);
      }
      
    }
    
    function pledge() onlyBeforeDistribution payable{
        balances[msg.sender] += msg.value;
        if (balances[msg.sender] == 0){
            pledgeAccounts.push(msg.sender);
        }
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    
}