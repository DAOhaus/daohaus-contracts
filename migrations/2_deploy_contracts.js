var HausToken = artifacts.require("./HausToken.sol");

module.exports = function(deployer) {
  deployer.deploy(HausToken);
};
