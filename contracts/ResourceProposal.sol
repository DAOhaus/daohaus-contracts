pragma solidity ^0.4.6;

import "./Stoppable.sol";
import "./Hub.sol";

contract ResourceProposal is Stoppable {

	int chairmanFee;
	uint deadline;
	address chairman;
	int projectCost;
	bytes32 proposalText;
	bool isDependent;
	address depParent;

	mapping(address => uint8) votes;
	//votes 0 is don't care, 1 yes, 2 no
	mapping(address => bytes32) opinions;

	modifier onlyIfMember(address a) {
		//require(isMember(a));
		_;
	}

	event LogProposalCreated(address owner, address chairmanAddress, int fees, uint blocks, int cost, bytes32 text);
	event LogVoteCast(address member, uint8 vote);
	event LogProposalSentToHub(address owner, uint blockNumber);
	event LogOpinionAdded(address member, bytes32 opinion);

	function ResourceProposal(address chairmanAddress, int fees, uint blocks, int cost, bytes32 text) {
		chairman = chairmanAddress;
		chairmanFee = fees;
		deadline = block.number + blocks;
		projectCost = cost;
		proposalText = text;
	}

	function getChairman()
		public
		constant
		returns(address)
	{
		return chairman;
	}

	function status()
		public
		constant
		returns(uint8)
	{
		//if(block.number > deadline) return DEADLINE_PASSED;
		//TODO: check for various conditions;
		return 2;

	}


	function castVote(uint8 voteOfMember)
		public
		onlyIfMember(msg.sender)
		onlyIfRunning
		returns(bool)
	{
		votes[msg.sender] = voteOfMember;

		LogVoteCast(msg.sender, voteOfMember);
		return true;
	}

	function giveOpinion(bytes32 opinion)
		public
		onlyIfMember(msg.sender)
		returns(bool)
	{
		opinions[msg.sender] = opinion;

		LogOpinionAdded(msg.sender, opinion);
		return true;
	}


	function sendToHub()
		public
		returns(bool)
	{

	}
}
