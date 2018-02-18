pragma solidity ^0.4.13;

import '../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract DictatorCoin is MintableToken {
  string public name = "Bubble Coin"; 
  string public symbol = "LBBL";
  uint public decimals = 18;
}