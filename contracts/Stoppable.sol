//////////////////////////////////////////////////////////
// For training purposes.
// Solidity Contract Factory 
// Module 5 - START
// Copyright (c) 2017, Rob Hitchens, all rights reserved.
// Not suitable for actual use
//////////////////////////////////////////////////////////

pragma solidity ^0.4.6;

import "./Owned.sol";

contract Stoppable is Owned {
    
    bool public running;
    
    event LogRunSwitch(address sender, bool switchSetting);
        
    modifier onlyIfRunning { 
        if(!running) throw; 
        _;
    }
        
    function Stoppable() {
        running = true;
    }
        
    function runSwitch(bool onOff)
        onlyOwner
        returns(bool success)
    {
        running = onOff;
        LogRunSwitch(msg.sender, onOff);
        return true;
    }
        
}