var frameworkCrowdsale = artifacts.require("FrameworkCrowdsale");

module.exports = function(deployer) {
  deployer.deploy(frameworkCrowdsale,  
      5000, 
      "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE", // Replace this wallet address with the last one (10th account) from Ganache UI. This will be treated as the beneficiary address. 
      500000000000000000000 // 500 ETH
    );
  };