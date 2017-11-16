pragma solidity ^0.4.15;

import "./deps/Stoppable.sol";
import "./deps/Logs.sol";
import "./Hub.sol";

contract ResourceProposal is Stoppable, Logs {

	uint public chairmanFee;
	uint public proposalCost;
	uint public deadline;
	address public chairman;
	string public proposalText;
	bool public isDependent;
	address public depParent;
	uint public status;

	mapping(address => uint8) votes;
	//votes 0 is don't care, 1 yes, 2 no
	mapping(address => bytes32) opinions;
	address[] public votesArray;

	modifier onlyIfMember() {
		Hub hubContract = Hub(owner);
		require(hubContract.isMember(msg.sender));
		_;
	}

	modifier onlyIfOracle() {
		_;
	}

	function ResourceProposal(address chairmanAddress, uint fees, uint blocks, uint cost, string text) public {
		chairman = chairmanAddress;
		proposalCost = cost;
		chairmanFee = fees;
		deadline = block.number + blocks;
		proposalText = text;
	}

	function getChairman()
		public
		constant
		returns(address)
	{
		return chairman;
	}

	function getVotes()
		public
		constant
		returns(address[])
	{
		// this is a hack... not sure why we need to times by 2
		uint count = 2*votesArray.length;

		address[] memory toReturn = new address[](count);

		for (uint i = 0; i<count; i += 2)
		{
			uint8 val = votes[votesArray[i]];
			if (val == 1 || val == 2){
				toReturn[i] = votesArray[i];
				toReturn[i+1] = address(val);
			}
		}

		return toReturn;
	}

	function getNumOfVotes()
		public
		constant
		returns(uint[])
	{
		uint count = votesArray.length;
		uint pos = 0; uint neg = 0;
		for (uint i = 0; i < count; i++)
		{
			uint8 val = votes[votesArray[i]];
			if (val == 1) pos++;
			else if (val == 2) neg++;
		}
		uint[] memory toReturn = new uint[](2);
		toReturn[0] = pos;
		toReturn[1] = neg;
		return toReturn;
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
		if (votes[msg.sender] == 0)
			votesArray.push(msg.sender);
		votes[msg.sender] = voteOfMember;

		LogVoteCast(msg.sender, voteOfMember);
		return true;
	}

	function getVotesArray()
		constant
		public
		returns (address[] arr)
	{
		return votesArray;
	}

	function getVote(address voter)
		constant
		public
		returns (uint8 vote)
	{
		return votes[voter];
	}

	function castVoteByText(uint8 voteOfMember, address memberAddr)
		public
		onlyIfOracle
		onlyIfRunning
		returns(bool)
	{
		if (votes[memberAddr] == 0)
			votesArray.push(memberAddr);
		votes[memberAddr] = voteOfMember;
		LogVoteCast(memberAddr, voteOfMember);
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

		for (uint i = 0; i < count; i++) {
			uint8 val = votes[votesArray[i]];

			if (val==1 || val==2) {
				addrForHub[i] = votesArray[i];
				votesForHub[i] = val;
			}
		}

		Hub hubContract = Hub(owner);
		status = hubContract.executeProposal(addrForHub,votesForHub, chairman, proposalCost+chairmanFee, deadline);
		LogProposalSentToHub(owner, block.number);
		return true;
	}
}