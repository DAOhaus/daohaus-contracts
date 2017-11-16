pragma solidity ^0.4.15;

import "./deps/Stoppable.sol";
import "./Hub.sol";

contract NonResourceProposal is Stoppable {

	uint deadline;
	uint status;
	uint value;
	string text;
	mapping(address => uint8) votes;
	address[] votesArray;

	event LogVoteCast(address member, uint8 vote);
	event LogNRProposalSentToHub(address owner, uint blockNumber);

	modifier onlyIfMember() {
		Hub hubContract = Hub(owner);
		require(hubContract.isMember(msg.sender));
		_;
	}

	function NonResourceProposal(uint blocks, uint val,string t) public {
		deadline = block.number + blocks;
		value = val;
		text = t;
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
		status = hubContract.executeNRProposal(addrForHub,votesForHub, deadline, value);
		LogNRProposalSentToHub(owner, block.number);
		return true;
	}
}