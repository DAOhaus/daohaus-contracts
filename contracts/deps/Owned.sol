pragma solidity ^0.4.15;

contract Owned {

    address public owner;

    event LogNewOwner(address sender, address oldOwner, address newOwner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }

}
