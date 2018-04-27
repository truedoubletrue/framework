pragma solidity ^0.4.18;

import "./ERC223Crowdsale.sol";
import "./MintableERC223Token.sol";


/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting. 
 */
contract MintedERC223Crowdsale is ERC223Crowdsale {

  /**
  * @dev Overrides delivery by minting tokens upon purchase.
  * @param _beneficiary Token purchaser
  * @param _tokenAmount Number of tokens to be minted
  */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    require(MintableERC223Token(token).mint(_beneficiary, _tokenAmount));
  }
}
