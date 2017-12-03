pragma solidity ^0.4.15;

import "./ResourceProposal.sol";
import "./NonResourceProposal.sol";
import "./deps/Owned.sol";
import "./deps/Logs.sol";

contract DictatorHub is Owned, Logs {

  address[] public members;
  uint public availableBalance;
  uint public runningBalance;
  uint public pvr;

  struct MemberDetails {
    string blockcomId; // used for future communications
    string name;
  }

  address[] public proposals;
  mapping(address => bool) proposalExists;
  mapping(address => MemberDetails) public memberDetails;
  //mapping(string=>address) public numberToAddress;

  mapping(address => uint) amountsPledgedMapping;
  mapping(address => bool) finishedProposals;
  mapping(address => uint) balances;

  modifier onlyIfProposal(address proposal) { require(proposalExists[proposal]); _; }
  modifier onlyIfMember() { require (amountsPledgedMapping[msg.sender] > 0); _; }

  function Hub() public {
    pvr = 75;
  }

  modifier sufficientFunds() {
    require(msg.value > 0);
    _;
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

  function register(string blockcomId, string name)
    public
    payable
    sufficientFunds()
    returns (bool)
  {
    /* update hub contract balance */
    availableBalance += msg.value;
    runningBalance += msg.value;

    /* update amountsPledged mapping */
    amountsPledgedMapping[msg.sender] += msg.value;
    memberDetails[msg.sender].blockcomId = blockcomId;
    memberDetails[msg.sender].name = name;
    members.push(msg.sender);

    LogMemberRegistered(
      msg.sender,
      name,
      blockcomId,
      msg.value,
      availableBalance,
      runningBalance
    );
    return true;
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
    require(availableBalance >= fees+cost);
    uint ind = proposals.length + 1;
    proposals.push(trustedProposal);
    proposalExists[trustedProposal] = true;
    availableBalance -= fees+cost;
    LogNewProposal(ind, chairmanAddress, fees, blocks, cost, text, trustedProposal);
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
      LogWithdraw(totFees, chairMan);
      chairMan.transfer(totFees);
      return 1;
    } else if (block.number > deadline) {
      finishedProposals[msg.sender] = true;
    }
    return 2;
  }

  function setPvr(uint val)
    private
    returns(bool)
  {
    pvr = val;
    return true;
  }

  function withdraw()
    public
    returns(bool)
  {
    // this should be to withdraw proof of stake tokens, once we get them
    // not the proposal amounts - needing refactor
    uint amt = balances[msg.sender];
    require(amt>0);
    balances[msg.sender] = 0;
    LogChairmanWithdraw(amt);
    msg.sender.transfer(amt);
    return true;
  }

  // Pass-through Admin Controls
  function stopProposal(address proposal)
      public
      onlyOwner()
      onlyIfProposal(proposal)
      returns(bool success)
  {
      ResourceProposal trustedProposal = ResourceProposal(proposal);
      return(trustedProposal.runSwitch(false));
  }
}
