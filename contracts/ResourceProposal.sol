pragma solidity ^0.4.6;

import "./Stoppable.sol";

contract ResourceProposal is Stoppable {

	int chairmanFee;
	uint deadline;
	address chairman;
	int projectCost;
	string proposalText;
	bool isDependent;
	address depParent;

	mapping(address => uint8) votes;
	//
	mapping(address => string) opinions;


	event LogProposalCreated(address owner, address chairmanAddress, int fees, uint blocks, int cost, string text);
	event LogVoteCast(address member, uint8 vote);
	event LogProposalSentToHub(address owner, uint blockNumber);
	event LogOpinionAdded(address member, bytes32 opinion);

	function ResourceProposal(address chairmanAddress, int fees, uint blocks, int cost, string text)
	{
		chairman = chairmanAddress;
		chairmanFee = fees;
		deadline = block.number + blocks;
		projectCost = cost;
		proposalText = text;
		LogProposalCreated(owner, chairmanAddress, fees, blocks, cost, text);
	}

	function castVote(uint8 vote)
	public
	returns(bool)
	{

	}
}
