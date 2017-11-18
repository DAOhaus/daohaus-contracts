pragma solidity ^0.4.15;

contract Registry {

    mapping (address => string) public phoneRegistry;

    function Registry() public {

    }

    function registerPhone(string number) public returns(bool sucess) {
        phoneRegistry[msg.sender] = number;
        return true;
    }
}