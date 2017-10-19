pragma solidity ^0.4.15;

import "./Stoppable.sol";

contract Hub is Stoppable {

  mapping (address => uint) amountsPledgedMapping;
  address[] members;
  uint public totalCurrentBalance;
  uint public totalAllTimeBalance;

  event LogMemberRegistered(address member, uint ethPledge, uint currentBalance, uint allTimeBalance);

  function Hub() {}

  function register()
    public
    payable
    sufficientFunds()
  {
    /* update hub contract balance */
    totalCurrentBalance += msg.value;
    totalAllTimeBalance += msg.value;

    /* update amountsPledged mapping */
    amountsPledgedMapping[msg.sender] += msg.value;

    /* update members array */
    members.push(msg.sender);

    LogMemberRegistered(
      msg.sender,
      msg.value,
      totalCurrentBalance,
      totalAllTimeBalance
    );
  }

  function getMembersCount()
    constant
    public
    returns (uint count)
  {
    return members.length;
  }

  function getVotingRightRatio(address member)
    constant
    public
    returns (uint ratio)
  {
    return amountsPledgedMapping[member] / totalAllTimeBalance;
  }

  /*function propose(uint ethAmount, string proposalMessage) {
    address proposer = msg.sender;
  }*/

  modifier sufficientFunds() {
    require(msg.value > 0);
    _;
  }

}
