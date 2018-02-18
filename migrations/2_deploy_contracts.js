// var Hub = artifacts.require("./Hub.sol");
// var DictatorHub = artifacts.require("./DictatorHub.sol");
var MintableToken = artifacts.require("./MintableToken.sol");

module.exports = function(deployer) {
  // deployer.deploy(Hub);
  // deployer.deploy(DictatorHub);
  deployer.deploy(MintableToken);
};
