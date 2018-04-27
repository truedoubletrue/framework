pragma solidity ^0.4.19;

/**
* @title ERC223 interface
* @dev see https://github.com/ethereum/eips/issues/223
*/
contract ERC223 {
    
    function name() public view returns (string name);
    function symbol() public view returns (string symbol);
    function decimals() public view returns (uint8 decimals);

    function balanceOf(address who) public constant returns (uint256 balanceOf);

    function transfer(address to, uint256 value) public returns (bool ok);
    function transfer(address to, uint256 value, bytes data) public returns (bool ok);
    function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool ok);
  
  	event Transfer(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
}
