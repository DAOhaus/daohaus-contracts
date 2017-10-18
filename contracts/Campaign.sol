
//////////////////////////////////////////////////////////
// For training purposes.
// Solidity Contract Factory 
// Module 5 - START
// Copyright (c) 2017, Rob Hitchens, all rights reserved.
// Not suitable for actual use
//////////////////////////////////////////////////////////

pragma solidity ^0.4.6;

import "./Stoppable.sol";

contract Campaign is Stoppable {
 
    address public sponsor;
    uint    public deadline;
    uint    public goal;
    uint    public fundsRaised;
    uint    public withdrawn;
    
    struct FunderStruct {
        uint amountContributed;
        uint amountRefunded;
    }
    
    mapping (address => FunderStruct) public funderStructs;
    
    modifier onlySponsor { 
        if(msg.sender != sponsor) throw;
        _; 
    }
    
    event LogContribution(address sender, uint amount);
    event LogRefundSent(address funder, uint amount);
    event LogWithdrawal(address beneficiary, uint amount);
    
    function Campaign(address campaignSponsor, uint campaignDuration, uint campaignGoal) {
        sponsor = campaignSponsor;
        deadline = block.number + campaignDuration;
        goal = campaignGoal;
    }
    
    function isSuccess()
        public
        constant
        returns(bool isIndeed)
    {
        return(fundsRaised >= goal);
    }
    
    function hasFailed()
        public
        constant
        returns(bool hasIndeed)
    {
        return(fundsRaised < goal && block.number > deadline);
    }
    
    function contribute() 
        public
        onlyIfRunning
        payable 
        returns(bool success) 
    {
        if(msg.value==0) throw;
        if(isSuccess()) throw;
        if(hasFailed()) throw;
        
        fundsRaised += msg.value;
        funderStructs[msg.sender].amountContributed += msg.value;
        LogContribution(msg.sender, msg.value);
        return true;
    }
    
    function withdrawFunds() 
        onlySponsor
        onlyIfRunning
        returns(bool success) 
    {
        if(!isSuccess()) throw;
        
        uint amount = fundsRaised - withdrawn;
        withdrawn += amount;
        if(!owner.send(amount)) throw;
        LogWithdrawal(owner, amount);
        return true;
    }
    
    function requestRefund()
        public
        onlyIfRunning
        returns(bool success) 
    {
        uint amountOwed = funderStructs[msg.sender].amountContributed - funderStructs[msg.sender].amountRefunded;
        if(amountOwed == 0) throw;
        if(!hasFailed()) throw;
        
        funderStructs[msg.sender].amountRefunded += amountOwed;
        if(!msg.sender.send(amountOwed)) throw;
        LogRefundSent(msg.sender, amountOwed);
        return true;
    }
    
}