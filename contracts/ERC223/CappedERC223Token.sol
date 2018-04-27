pragma solidity ^0.4.19;

import "./MintableERC223Token.sol";


/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract CappedERC223Token is MintableERC223Token {

  uint256 public cap;

  function CappedERC223Token(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    require(totalSupply.add(_amount) <= cap);

    return super.mint(_to, _amount);
  }

}
