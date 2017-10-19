pragma solidity ^0.4.15;

import "./Stoppable.sol";

contract Hub is Stoppable {

  mapping (address => uint) amountsPledgedMapping;
  address[] members;
  uint public totalBalance;

  event LogMemberRegistered(address member, uint ethPledge, uint totalContractBalance);

  function DaohausHub() {}

  function register()
    public
    payable
    sufficientFunds()
  {
    /* update hub contract balance */
    totalBalance += msg.value;

    /* update amountsPledged mapping */
    amountsPledgedMapping[msg.sender] = msg.value;

    /* update members array */
    members.push(msg.sender);

    LogMemberRegistered(
      msg.sender,
      msg.value,
      totalBalance
    );
  }

  function getMembersCount()
    constant
    public
    returns (uint count)
  {
    return members.length;
  }

  /*function propose(uint ethAmount, string proposalMessage) {
    address proposer = msg.sender;
  }*/

  modifier sufficientFunds() {
    require(msg.value > 0);
    _;
  }

}
