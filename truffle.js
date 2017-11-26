const constants = require('./constants');
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*", // Match any network id
      gas:   8900000
    }
    // ,ropsten: {
    //   provider: new HDWalletProvider(constants.mnemonic, "https://ropsten.infura.io/" + constants.infura_apikey, constants.address),
    //   network_id: 3,
    //   gas:   2900000
    // }
  }
};
