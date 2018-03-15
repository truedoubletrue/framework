pragma solidity ^0.4.19;

import './ERC223.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract ERC223Token is ERC20, ERC223, Ownable{
  // Overrides the ERC20 transfer function 
  function transfer(address _to, uint _value) public returns (bool success) {
      return transfer(_to, _value, new bytes(0));
  }
  
  // Overrides the ERC20 transferFrom function 
  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
      return transferFrom(_from, _to, _value, new bytes(0));
  }
  
  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
      //filtering if the target is a contract with bytecode inside it
      require(super.transfer(_to, _value)); // do a normal token transfer
      if (isContract(_to)) {
          require(contractFallback(msg.sender, _to, _value, _data));
      }
      return true;
  }
    
  // ERC223 transferFrom function
  function transferFrom(address _from, address _to, uint _value, bytes _data) public onlyOwner returns (bool success) {
      require(super.transferFrom(_from, _to, _value)); // do a normal token transfer
      if (isContract(_to)) {
          require(contractFallback(_from, _to, _value, _data));
      }
      return true;
  }
  
  //function that is called when transaction target is a contract
  function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool) {
      ERC223Receiver receiver = ERC223Receiver(_to);
      receiver.tokenFallback(_origin, _value, _data);
      ContractTransfer(_origin, _to, _value, _data);
      return true;
  }

  //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
  function isContract(address _addr) private view returns (bool is_contract) {
      uint length;
      assembly { length := extcodesize(_addr) }
      return length > 0;
  }
}
