pragma solidity ^0.4.15;
contract Logs {
  // HUB
  event LogMemberRegistered(address member, string name, string blockcomId, uint ethPledge, uint _availableBalance, uint _runningBalance);
  event LogNewProposal(uint pid, address chairmanAddress, uint fees, uint blocks, uint cost, string text, address proposalAddress);
  event LogNewNRProposal(uint pid, uint deadline, uint val, string text, address proposalAddress);
  event LogChairmanWithdraw(uint amount);
  event LogWithdraw(uint amount, address toAddress);

  // RESOURCE PROPOSAL
  //event LogProposalCreated(address owner, address chairmanAddress, uint fees, uint blocks, uint cost, bytes32 text);
  event LogVoteCast(address member, uint8 vote);
	event LogProposalSentToHub(address owner, uint blockNumber);
	event LogOpinionAdded(address member, bytes32 opinion);
}