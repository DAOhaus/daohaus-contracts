pragma solidity ^0.4.15;

import "./ResourceProposal.sol";
import "./Owned.sol";

contract Hub is Owned {

  address[] members;
  uint public availableBalance;
  uint public runningBalance;

  address[] public proposals;
  mapping(address => bool) proposalExists;
  mapping (address => uint) amountsPledgedMapping;

  modifier onlyIfProposal(address proposal) {
    require(proposalExists[proposal]);
    _;
  }

  modifier onlyIfMember() {
    require (amountsPledgedMapping[msg.sender] > 0);
    _;
  }

  event LogMemberRegistered(address member, uint ethPledge, uint _availableBalance, uint _runningBalance);
  event LogNewProposal(address chairmanAddress, int fees, uint blocks, int cost, bytes32 text);

  function Hub() {

  }

  function isMember(address person)
  public
  constant
  returns (bool)
  {
   return amountsPledgedMapping[person] > 0;
  }

  function register()
    public
    payable
    sufficientFunds()
  {
    /* update hub contract balance */
    availableBalance += msg.value;
    runningBalance += msg.value;

    /* update amountsPledged mapping */
    amountsPledgedMapping[msg.sender] += msg.value;

    /* update members array */
    members.push(msg.sender);

    LogMemberRegistered(
      msg.sender,
      msg.value,
      availableBalance,
      runningBalance
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
    return (amountsPledgedMapping[member] / runningBalance) * 100;
  }

  /*function propose(uint ethAmount, string proposalMessage) {
    address proposer = msg.sender;
  }*/

  modifier sufficientFunds() {
    require(msg.value > 0);
    _;
  }

   function getProposalCount()
        public
        constant
        returns(uint proposalCount)
    {
        return proposals.length;
    }

    function createResourceProposal(
      address chairmanAddress,
      int fees,
      uint blocks,
      int cost,
      bytes32 text
    )
        public
        onlyIfMember
        returns(address proposalContract)
    {
      ResourceProposal trustedProposal = new ResourceProposal(
        chairmanAddress,
        fees,
        blocks,
        cost,
        text
      );
      proposals.push(trustedProposal);
      proposalExists[trustedProposal] = true;
      LogNewProposal(chairmanAddress, fees, blocks, cost, text);
      return trustedProposal;
    }

    // Pass-through Admin Controls
    function stopProposal(address proposal)
        onlyOwner()
        onlyIfProposal(proposal)
        returns(bool success)
    {
        ResourceProposal trustedProposal = ResourceProposal(proposal);
        return(trustedProposal.runSwitch(false));
    }

}
