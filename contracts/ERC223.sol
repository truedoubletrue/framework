pragma solidity ^0.4.19;

import './ERC223Receiver.sol';

contract ERC223 is ERC223Receiver {
  function transfer(address to, uint value, bytes data) public returns (bool ok);
  function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
  
  event ContractTransfer(address indexed _from, address indexed _to, uint _value, bytes _data);
}
