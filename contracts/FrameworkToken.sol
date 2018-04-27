pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';

import './ERC223/ERC223Token.sol';
//import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract FrameworkToken is ERC223Token, Pausable, Contactable {
  string public name = "Framework";
  string public symbol = "FRWK";
  uint8 public decimals = 18;
  //uint256 public cappedTokenSupply = 100000000 * (10 ** uint256(decimals)); // There will be total 100 million FRWK Tokens
  
  /*function FrameworkToken(uint256 cappedTokenSupply) CappedERC223Token(cappedTokenSupply) public {
  	
  }

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool _success) {
    return super.transfer(_to, _value);
  }

  function transfer(address _to, uint256 _value, bytes _data, string _fallback) public whenNotPaused returns (bool _success) {
  	return super.transfer(_to, _value, _data, _fallback);
  }

  function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool _success) {
  	return super.transfer(_to, _value, _data);
  }
*/
}

