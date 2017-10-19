//////////////////////////////////////////////////////////
// For training purposes.
// Solidity Contract Factory
// Module 5 - START
// Copyright (c) 2017, Rob Hitchens, all rights reserved.
// Not suitable for actual use
//////////////////////////////////////////////////////////

pragma solidity ^0.4.6;

contract Owned {

    address public owner;

    event LogNewOwner(address sender, address oldOwner, address newOwner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function Owned() {
        owner = msg.sender;
    }

    function changeOwner(address newOwner)
        onlyOwner
        returns(bool success)
    {
        require(newOwner != 0);
        LogNewOwner(msg.sender, owner, newOwner);
        owner = newOwner;
        return true;
    }

}
