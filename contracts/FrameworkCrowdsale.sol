pragma solidity ^0.4.19;

import './FrameworkToken.sol';

import 'zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';



contract FrameworkCrowdsale is CappedCrowdsale, Ownable {

  uint8 decimals=18;  //this should match the FrameworkToken value
  // ============
  enum CrowdsaleStage { PS_R1, PS_R2, PS_R3, PS_R4, PS_R5, PS_R6, PS_R7, ICO }
  CrowdsaleStage public stage = CrowdsaleStage.PS_R1; // By default it's Pre Sale Round 1
  // =============

  // Token Distribution
  // =============================
  uint256 public maxTokens = 10000000 * (10 ** uint256(decimals)); // There will be total 10 million FRWK Tokens
  uint256 public tokensForEcosystem = 2000000 * (10 ** uint256(decimals)); // 2 million for the eco system reserve
  uint256 public tokensForTeam = 2000000 * (10 ** uint256(decimals)); // 2 million for the FRWK team
  uint256 public tokensForBounty = 100000 * (10 ** uint256(decimals)); // 100k for token bounty reserve
  uint256 public totalTokensForSale = 6000000 * (10 ** uint256(decimals)); // 6 million FRWK Tokens will be sold in Crowdsale
  uint256 public totalTokensForSaleDuringPreICO = 2000000 * (10 ** uint256(decimals)); // 2 million out of 6 million FRWKs will be sold during PreICO
  // ==============================
  
  // Token Funding Rates
  // ==============================
  uint256 public DEFAULT_RATE = 5000;
  uint256 public ROUND_1_PRESALE_BONUS = 1750; //35%
  uint256 public ROUND_2_PRESALE_BONUS = 1500; //30%
  uint256 public ROUND_3_PRESALE_BONUS = 1250; //25%
  uint256 public ROUND_4_PRESALE_BONUS = 1000; //20%
  uint256 public ROUND_5_PRESALE_BONUS = 750; //15%
  uint256 public ROUND_6_PRESALE_BONUS = 500; //10%
  uint256 public ROUND_7_PRESALE_BONUS = 250; //5%
  uint256 public ICO_BONUS = 0;

  // Amount raised in PreICO
  // ==================
  uint256 public totalWeiRaisedDuringPreICO;
  // ===================

  bool finishedCrowdsale = false;

  // Events
  event EthTransferred(string text);
  event EthRefunded(string text);
  
  function FrameworkCrowdsale(uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) Crowdsale(_rate, _wallet, createTokenContract()) public {
    require(_goal <= _cap);	
  }
  
  function createTokenContract() internal returns (MintableToken) {
    return new FrameworkToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
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

    function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {
        if (!finishedCrowdsale){
            uint256 alreadyMinted = token.totalSupply();
            require(alreadyMinted < maxTokens);

            uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
            if (unsoldTokens > 0) {
                tokensForEcosystem = tokensForEcosystem + unsoldTokens;
            }

            MintableToken(token).mint(_teamFund,tokensForTeam);
            MintableToken(token).mint(_ecosystemFund,tokensForEcosystem);
            MintableToken(token).mint(_bountyFund,tokensForBounty);
            finishedCrowdsale = true;
        }
    }
  // ===============================
}
