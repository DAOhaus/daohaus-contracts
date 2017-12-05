pragma solidity ^0.4.15;

import "./Hub.sol";
import "./ResourceProposal.sol";
import "./NonResourceProposal.sol";
import "./deps/Owned.sol";
import "./deps/Logs.sol";

contract DictatorHub is Hub {

  bool public isDictator;

  // diff: places a flag on contract to easily see it's a dictator
  // diff: automatically adds dictator as member
  function DictatorHub() public {
    pvr = 75;
    isDictator = true;
    members.push(msg.sender);
  }

  // diff: only allows dictator to register members
  // diff: voting weight decided at registration, not on how much is pledged
  function register(address accountAddress, uint weight, string blockcomId, string name)
    public
    payable
    // onlyOwner()
    returns (bool)
  {

    /* update amountsPledged mapping */
    amountsPledgedMapping[accountAddress] += weight;
    memberDetails[accountAddress].blockcomId = blockcomId;
    memberDetails[accountAddress].name = name;
    members.push(accountAddress);

    LogMemberRegistered(
      accountAddress,
      name,
      blockcomId,
      weight,
      availableBalance,
      runningBalance
    );
    return true;
  }


  // address[] public members;
  // uint public availableBalance;
  // uint public runningBalance;
  // uint public pvr;
  // struct MemberDetails
  // address[] public proposals;
  
  // mapping(address => bool) proposalExists;
  // mapping(address => MemberDetails) public memberDetails;
  // mapping(string=>address) public numberToAddress;
  // mapping(address => uint) amountsPledgedMapping;
  // mapping(address => bool) finishedProposals;
  // mapping(address => uint) balances;

  // modifier onlyIfProposal(address proposal) { require(proposalExists[proposal]); _; }
  // modifier onlyIfMember() { require (amountsPledgedMapping[msg.sender] > 0); _; }
  // modifier sufficientFunds() { require(msg.value > 0); _; }

  // function setPvr(uint val)
  // function getMembers()
  // function isMember(address person)
  // function getMembersCount()
  // function getVotingRightRatio(address member)
  // function getProposals()
  // function createResourceProposal(
  // function withdraw()
  // function stopProposal(address proposal)
}
