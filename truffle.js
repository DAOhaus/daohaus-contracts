const constants = require('./constants');
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    }
    // },
    // ropsten: {
    //   provider: new HDWalletProvider(constants.mnemonic, "https://ropsten.infura.io/" + constants.infura_apikey),
    //   network_id: 3,
    //   gas:   1900000
    // }
  }
};
