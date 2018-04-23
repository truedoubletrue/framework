pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/ownership/Contactable.sol';

import 'zeppelin-solidity/contracts/token/ERC20/CappedToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import './ERC223/ERC223Token.sol';

contract FrameworkToken is CappedToken, ERC223Token, PausableToken, Contactable {
  string public name = "Framework";
  string public symbol = "FRWK";
  uint8 public decimals = 18;
  uint256 public cappedTokenSupply = 100000000 * (10 ** uint256(decimals)); // There will be total 100 million FRWK Tokens
  
  function FrameworkToken() CappedToken(cappedTokenSupply) public {
  	
  }
}

