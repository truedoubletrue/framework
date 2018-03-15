module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "localhost",
      port: 9545,
      gas: 6500000,
      network_id: "5777"
    }
  },
  solc: {
     optimizer: {
       enabled: true,
       runs: 200
     }
  }
};
