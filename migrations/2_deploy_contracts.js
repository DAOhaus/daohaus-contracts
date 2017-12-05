var Hub = artifacts.require("./Hub.sol");
var DictatorHub = artifacts.require("./DictatorHub.sol");

module.exports = function(deployer) {
  deployer.deploy(Hub);
  deployer.deploy(DictatorHub);
};
