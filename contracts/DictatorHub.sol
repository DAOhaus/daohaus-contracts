pragma solidity ^0.4.15;

import "./Hub.sol";

contract DictatorHub is Hub {

  function DictatorHub() public {
    pvr = 75;
    members.push(msg.sender);
  }

  function dictatorRegister(address newUser, uint weight, string blockcomId, string name)
    public
    payable
    onlyOwner()
    returns (bool)
  {
    /* update amountsPledged mapping */
    amountsPledgedMapping[newUser] += weight;
    memberDetails[newUser].blockcomId = blockcomId;
    memberDetails[newUser].name = name;

    //numberToAddress[blockcomId] = msg.sender;
    /* update members array */
    //if(memberDetails[msg.sender].blockcomId == "")
    members.push(newUser);

    LogMemberRegistered(
      newUser,
      name,
      blockcomId,
      weight,
      availableBalance,
      runningBalance
    );
    return true;
  }

  function anonymousFund() public payable returns(bool) {
    /* catch all to update hub contract balance */
    availableBalance += msg.value;
    runningBalance += msg.value;
    return true;
  }
}
