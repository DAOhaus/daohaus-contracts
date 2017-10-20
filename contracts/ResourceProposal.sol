pragma solidity ^0.4.15;

import "./Stoppable.sol";
import "./Hub.sol";

contract ResourceProposal is Stoppable {

	uint chairmanFee;
	uint deadline;
	address chairman;
	uint projectCost;
	bytes32 proposalText;
	bool isDependent;
	address depParent;
	uint status;

	mapping(address => uint8) votes;
	//votes 0 is don't care, 1 yes, 2 no
	mapping(address => bytes32) opinions;
	address[] votesArray;

	modifier onlyIfMember() {
		Hub hubContract = Hub(owner);
		require(hubContract.isMember(msg.sender));
		_;
	}

	//event LogProposalCreated(address owner, address chairmanAddress, uint fees, uint blocks, uint cost, bytes32 text);
	event LogVoteCast(address member, uint8 vote);
	event LogProposalSentToHub(address owner, uint blockNumber);
	event LogOpinionAdded(address member, bytes32 opinion);

	function ResourceProposal(address chairmanAddress, uint fees, uint blocks, uint cost, bytes32 text) {
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


	function getStatus()
		public
		constant
		returns(uint)
	{
		return status;
	}


	function castVote(uint8 voteOfMember)
		public
		onlyIfMember
		onlyIfRunning
		returns(bool)
	{
		votes[msg.sender] = voteOfMember;
		votesArray.push(msg.sender);
		LogVoteCast(msg.sender, voteOfMember);
		return true;
	}

	function giveOpinion(bytes32 opinion)
		public
		onlyIfMember
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

		uint count = votesArray.length;

		address[] memory addrForHub = new address[](count);
		uint8[] memory votesForHub = new uint8[](count);

		for(uint i=0; i<count; i++)
		{
			uint8 val = votes[votesArray[i]];

			if(val==1 || val==2){
				addrForHub[i] = votesArray[i];
				votesForHub[i] = val;
			}
		}

		Hub hubContract = Hub(owner);
		status = hubContract.executeProposal(addrForHub,votesForHub, chairman, projectCost+chairmanFee, deadline);
		LogProposalSentToHub(owner, block.number);
		return true;
	}
}
