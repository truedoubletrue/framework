pragma solidity ^0.4.19;

/**
* @title ERC223 interface
* @dev see https://github.com/ethereum/eips/issues/223
*/
contract ERC223 {
    function transfer(address _to, uint _value, bytes _data) public returns (bool success);
    function transfer(address _to, uint _value, bytes _data, string _fallback) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
}
