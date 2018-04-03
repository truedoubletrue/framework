# framework

## Requirements
Requirements:
- Install Node 9+
- Install npm 5+
- Install Zeppelin - npm install zeppelin-solidity@1.7.0
- Install truffle  - npm install -g truffle

##Building
Uses truffle.

Some commands

Compile contracts in contract directory:
> truffle compile

Run token migrations on migrations directory:
> truffle migrate --network gapp (when using Ganache.app)
> truffle migrate --network local (when using ganache-cli)
> truffle develop
   truffle(develop)> migrate (when using develop option) 

Running tests that are in the test directory:
> truffle test

Viewing network configuration:
> truffle networks

