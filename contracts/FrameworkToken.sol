pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
// Destructible Token?? 

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import './ERC223/ERC223Token.sol';
import './MembershipAccessControl.sol';

contract FrameworkToken is MintableToken, ERC223Token, MembershipAccessControl {
  string public name = "Framework";
  string public symbol = "FRWK";
  uint8 public decimals = 18;
  
}

