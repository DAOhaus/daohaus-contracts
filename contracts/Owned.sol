pragma solidity ^0.4.16;

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
