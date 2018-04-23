var frameworkInvest = artifacts.require("FrameworkInvest");
var frameworkToken = artifacts.require("FrameworkToken");

module.exports = function(deployer, network, accounts) {
	const rate = new web3.BigNumber(500);
    const cap = new web3.BigNumber(100000000000000000000000000);
	const wallet = accounts[1];
	
	return deployer.then(() => {
		return deployer.deploy(frameworkToken);
	})
		.then(() => {
			return deployer.deploy(			
				frameworkInvest,  
				rate, //500 tokens per ether
				wallet,//"0xD43FC396fc0E7bcc0dDe7c9BCe1936d1b24B0f4a", // Replace this wallet address with the last one (10th account) from Ganache UI. This will be treated as the beneficiary address. 
				cap,// 100 million token cap
				frameworkToken.address
    		);
		});
  };