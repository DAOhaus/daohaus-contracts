pragma solidity ^0.4.15;

import "./Stoppable.sol";
import "./Hub.sol";

contract NonResourceProposal is Stoppable {

	event LogVoteCast(address member, uint8 vote);
	event LogProposalSentNPRToHub(address owner, uint blockNumber);

	mapping(address => uint8) votes;
	//votes 0 is don't care, 1 yes, 2 no
	mapping(address => bytes32) opinions;
	address[] votesArray;
	//mapping(bytes32 => uint) possibleTypes;
	uint deadline;
	uint valueOfResource;
	bytes32 typeOfResource;

	function NonResourceProposal(bytes32 t, uint blocks, uint val) {
		//possibleTypes["pvr"] = 1;
		//possibleTypes["tax"] = 2;
		//require(type=="pvr");
		typeOfResource = t;
		valueOfResource = val;
		deadline = block.number + blocks;
	}

	modifier onlyIfMember() {
		Hub hubContract = Hub(owner);
		require(hubContract.isMember(msg.sender));
		_;
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

	function sendNRPToHub()
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
		//status = hubContract.executeNRProposal(addrForHub, votesForHub, typeOfResource, deadline, valueOfResource);
		//LogProposalSentNPRToHub(owner, block.number);
		return true;
	}

}