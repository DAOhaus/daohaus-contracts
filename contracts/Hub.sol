//////////////////////////////////////////////////////////
// For training purposes.
// Solidity Contract Factory 
// Module 5
// Copyright (c) 2017, Rob Hitchens, all rights reserved.
// Not suitable for actual use
//////////////////////////////////////////////////////////

pragma solidity ^0.4.6;

import "./Owned.sol";
import "./ResourceProposal.sol";

contract Hub is Owned {
    
    address[] public proposals;
    mapping(address => bool) proposalExists;
    
    modifier onlyIfCampaign(address proposal) {
        if (proposalExists[proposal] != true) {
            revert();
        }
        _;
    }
    
    event LogNewCampaign(address sponsor, address proposal, uint duration, uint goal);
    
    function getProposalCount()
        public
        constant
        returns(uint campaignCount)
    {
        return proposals.length;
    }
    
    function createResourceProposal(uint campaignDuration, uint campaignGoal)
        public
        returns(address campaignContract)
    {
        ResourceProposal trustedProposal = new ResourceProposal(msg.sender); // put in params that are needed for resourced
        proposals.push(trustedCampaign);
        proposals[trustedProposal] = true;
        LogNewProposal(msg.sender); // new params needed
        return trustedCampaign;
    }
    
    // Pass-through Admin Controls
    function stopProposal(address proposal) 
        onlyOwner
        onlyIfCampaign(campaign)
        returns(bool success)
    {
        ResourceProposal trustedProposal = ResourceProposal(proposal);
        LogCampaignStopped(msg.sender, campaign);
        return(trustedProposal.runSwitch(false));
    }
}