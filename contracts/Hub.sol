pragma solidity ^0.4.15;

import "./ResourceProposal.sol";
import "./NonResourceProposal.sol";
import "./Owned.sol";

contract Hub is Owned {

  address[] public members;
  uint public availableBalance;
  uint public runningBalance;
  uint public pvr;

  struct MemberDetails {
    string number;
    string name;
  }

  address[] public proposals;
  mapping(address => bool) proposalExists;
  mapping(address => MemberDetails) public memberDetails;
  //mapping(string=>address) public numberToAddress;

  mapping(address => uint) amountsPledgedMapping;
  mapping(address => bool) finishedProposals;
  mapping(address => uint) balances;

  modifier onlyIfProposal(address proposal) {
    require(proposalExists[proposal]);
    _;
  }

  modifier onlyIfMember() {
    require (amountsPledgedMapping[msg.sender] > 0);
    _;
  }

  event LogMemberRegistered(address member, string name, string phoneNumber, uint ethPledge, uint _availableBalance, uint _runningBalance);
  event LogNewProposal(uint pid, address chairmanAddress, uint fees, uint blocks, uint cost, string text, address proposalAddress);
  event LogNewNRProposal(uint pid, uint deadline, uint val, string text, address proposalAddress);
  event LogChairmanWithdraw(uint amount);

  function Hub() {
    pvr = 75;
  }

  function getMembers()
    constant
    public
    returns (address[] arr)
  {
    return members;
  }

  function isMember(address person)
    public
    constant
    returns (bool)
  {
   return amountsPledgedMapping[person] > 0;
  }

  function register(string phoneNumber, string name)
    public
    payable
    sufficientFunds()
  {
    /* update hub contract balance */
    availableBalance += msg.value;
    runningBalance += msg.value;

    /* update amountsPledged mapping */
    amountsPledgedMapping[msg.sender] += msg.value;
    memberDetails[msg.sender].number = phoneNumber;
    memberDetails[msg.sender].name = name;

    //numberToAddress[phoneNumber] = msg.sender;
    /* update members array */
    //if(memberDetails[msg.sender].phoneNumber == "")
    members.push(msg.sender);

    LogMemberRegistered(
      msg.sender,
      name,
      phoneNumber,
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
    return amountsPledgedMapping[member] * 100 / runningBalance;
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

  function getProposals()
    constant
    public
    returns (address[] arr)
  {
    return proposals;
  }

  function createResourceProposal(
    address chairmanAddress,
    uint fees,
    uint blocks,
    uint cost,
    string text
  )
    public
    //onlyIfMember
    returns(address proposalContract)
  {
    ResourceProposal trustedProposal = new ResourceProposal(
      chairmanAddress,
      fees,
      blocks,
      cost,
      text
    );
    uint ind = proposals.length + 1;
    proposals.push(trustedProposal);
    proposalExists[trustedProposal] = true;
    LogNewProposal(ind, chairmanAddress, fees, blocks, cost, text, trustedProposal);
    return trustedProposal;
  }

  function createNonResourceProposal(
    uint val,
    uint blocks,
    string text
  )
      public
      onlyIfMember
      returns(address proposalContract)
  {
    NonResourceProposal trustedProposal = new NonResourceProposal(
      blocks,
      val,
      text
    );
    uint ind = proposals.length + 1;
    proposals.push(trustedProposal);
    proposalExists[trustedProposal] = true;
    LogNewNRProposal(ind, blocks, val, text, trustedProposal);
    return trustedProposal;
  }

  function executeProposal(address[] addrForHub, uint8[] votesForHub, address chairMan, uint totFees, uint deadline)
    public
    returns(uint)
  {
    require(!finishedProposals[msg.sender]);
    uint count = addrForHub.length;
    uint pos = 0;
    uint total = 0;
    for (uint i = 0; i < count; i++) {
      if (isMember(addrForHub[i])) {
        uint ratio = getVotingRightRatio(addrForHub[i]);
        if (votesForHub[i]==1) {
          pos += ratio;
        }
        total += ratio;
      }
    }

    uint cpvr = pos*100/100;
    if (cpvr >= pvr) {
      finishedProposals[msg.sender] = true;
      balances[chairMan] += totFees;
      return 1;
    } else if (block.number > deadline) {
      finishedProposals[msg.sender] = true;
    }
    return 2;
  }

    function getPvr()
      public
      constant
      returns(uint)
    {
      return pvr;
    }

  function setPvr(uint val)
    private
    returns(bool)
  {
    pvr = val;
    return true;
  }

  function executeNRProposal(address[] addrForHub,uint8[] votesForHub, uint deadline, uint val)
    public
    returns(uint)
  {
    require(!finishedProposals[msg.sender]);
    uint count = addrForHub.length;
    uint pos = 0;
    uint total = 0;
    for(uint i=0;i<count;i++)
    {
      if(isMember(addrForHub[i])){
        uint ratio = getVotingRightRatio(addrForHub[i]);
        if(votesForHub[i]==1) {
          pos+=ratio;
        }
        total+=ratio;
      }
    }
    uint cpvr = pos*100/100;
    if(cpvr>=pvr){
      finishedProposals[msg.sender] = true;
      require(setPvr(val));
      //balances[chairMan]+=totFees;
      return 1;
    }
    else if(block.number> deadline){
      finishedProposals[msg.sender] = true;
    }

    return 2;
  }

  function withdraw()
    public
    returns(bool)
  {
    uint amt = balances[msg.sender];
    require(amt>0);
    balances[msg.sender] = 0;
    LogChairmanWithdraw(amt);
    msg.sender.transfer(amt);
    return true;
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
