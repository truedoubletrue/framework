pragma solidity ^0.4.19;

import './FrameworkToken.sol';
import './ERC223/MintedERC223Crowdsale.sol';
import './ERC223/CappedERC223Crowdsale.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';



contract FrameworkInvest is CappedERC223Crowdsale, MintedERC223Crowdsale, Ownable {

  uint8 decimals = 18;  //this should be the token value
  // ============
  enum CrowdsaleStage { PS_R1, PS_R2, PS_R3, PS_R4, PS_R5, PS_R6, PS_R7, ICO }
  CrowdsaleStage public stage = CrowdsaleStage.PS_R1; // By default it's Pre Sale Round 1
  // =============

  // Token Distribution
  // =============================
  uint256 public maxTokens = 100000000 * (10 ** uint256(decimals)); // There will be total 20 million FRWK Tokens available for sale
  uint256 public tokensForReserve = 40000000 * (10 ** uint256(decimals)); // 40 million for the eco system reserve
  uint256 public tokensForBounty = 1000000 * (10 ** uint256(decimals)); // 1 million for token bounty reserve
  uint256 public totalTokensForSale = 50000000 * (10 ** uint256(decimals)); // 50 million FRWK Tokens will be sold in Crowdsale
  uint256 public totalTokensForSaleDuringPreICO = 20000000 * (10 ** uint256(decimals)); // 20 million out of 6 million FRWKs will be sold during PreICO
  // ==============================
  
  // Token Funding Rates
  // ==============================
  uint256 public DEFAULT_RATE = 500;
  uint256 public ROUND_1_PRESALE_BONUS = 175; //35%
  uint256 public ROUND_2_PRESALE_BONUS = 150; //30%
  uint256 public ROUND_3_PRESALE_BONUS = 125; //25%
  uint256 public ROUND_4_PRESALE_BONUS = 100; //20%
  uint256 public ROUND_5_PRESALE_BONUS = 75; //15%
  uint256 public ROUND_6_PRESALE_BONUS = 50; //10%
  uint256 public ROUND_7_PRESALE_BONUS = 25; //5%
  uint256 public ICO_BONUS = 0;

  // Amount raised in PreICO
  // ==================
  uint256 public totalWeiRaisedDuringPreICO;
  // ===================

  bool public crowdsaleStarted = true;

  // Events
  event EthTransferred(string text);
  event EthRefunded(string text);
  
  function FrameworkInvest(uint256 _rate, address _wallet, uint256 _cap, CappedERC223Token _token) CappedERC223Crowdsale(_cap) ERC223Crowdsale(_rate, _wallet, _token) public {
  }
  
  
  // Crowdsale Stage Management
    // =========================================================
    function setCrowdsaleStage(uint value) public onlyOwner {

        CrowdsaleStage _stage;

        if (uint(CrowdsaleStage.PS_R1) == value) {
          _stage = CrowdsaleStage.PS_R1;
          calculateAndSetRate(ROUND_1_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R2) == value) {
          _stage = CrowdsaleStage.PS_R2;
          calculateAndSetRate(ROUND_2_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R3) == value) {
          _stage = CrowdsaleStage.PS_R3;
          calculateAndSetRate(ROUND_3_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R4) == value) {
          _stage = CrowdsaleStage.PS_R4;
          calculateAndSetRate(ROUND_4_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R5) == value) {
          _stage = CrowdsaleStage.PS_R5;
          calculateAndSetRate(ROUND_5_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R6) == value) {
          _stage = CrowdsaleStage.PS_R6;
          calculateAndSetRate(ROUND_6_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.PS_R7) == value) {
          _stage = CrowdsaleStage.PS_R7;
          calculateAndSetRate(ROUND_7_PRESALE_BONUS);
        } else if (uint(CrowdsaleStage.ICO) == value) {
          _stage = CrowdsaleStage.ICO;
          calculateAndSetRate(ICO_BONUS);
        }

        stage = _stage;
    }

    // Change the current rate
    function setCurrentRate(uint256 _rate) private {
        rate = _rate;
    }

    // Change the current rate
    function calculateAndSetRate(uint256 _bonus) private {
        uint256 calcRate = DEFAULT_RATE + _bonus;
        setCurrentRate(calcRate);
    }
    
    function setRate(uint256 _rate) public onlyOwner {
        setCurrentRate(_rate);
    }
    
    function setCrowdSale(bool _started) public onlyOwner {
        crowdsaleStarted = _started;
    }
  // ================ Stage Management Over =====================
  
    // Token Purchase
    // =========================
    function () external payable {
        uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
        if ((stage != CrowdsaleStage.ICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
          msg.sender.transfer(msg.value); // Refund them
          EthRefunded("Presale Limit Hit.");
          return;
        }

        buyTokens(msg.sender);
        EthTransferred("Transferred funds to wallet.");
        
        if (stage != CrowdsaleStage.ICO) {
            totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
        }
    }

    // ===========================
    // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
    // ====================================================================

    function finish(address _reserveFund, address _bountyFund) public onlyOwner {
        if (crowdsaleStarted){
            uint256 alreadyMinted = token.totalSupply();
            require(alreadyMinted < maxTokens);

            uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
            if (unsoldTokens > 0) {
                tokensForReserve = tokensForReserve + unsoldTokens;
            }
            MintableERC223Token(token).mint(_reserveFund,tokensForReserve);
            MintableERC223Token(token).mint(_bountyFund,tokensForBounty);
            crowdsaleStarted = false;
        }
    }
  // ===============================
}
