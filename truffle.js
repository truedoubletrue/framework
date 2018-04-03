
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    gapp: { //ganache app
      host: "localhost",
      port: 7545,
		network_id: "1000"
    },
    local: { //ganache-cli
      host: "localhost",
      port: 8545,
		network_id: "*"
    }
  },
  solc: {
     optimizer: {
       enabled: true,
       runs: 200
     }
  }
};
