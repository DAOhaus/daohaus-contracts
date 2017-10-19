/*
This test file contains all 6 test scenarios that we are required to write
*/
const expectedExceptionPromise = require("../utils/expectedException.js");
web3.eth.getTransactionReceiptMined = require("../utils/getTransactionReceiptMined.js");
Promise = require("bluebird");
Promise.allNamed = require("../utils/sequentialPromiseNamed.js");
const randomIntIn = require("../utils/randomIntIn.js");
const toBytes32 = require("../utils/toBytes32.js");

if (typeof web3.eth.getAccountsPromise === "undefined") {
    Promise.promisifyAll(web3.eth, { suffix: "Promise" });
}

const DaohausHub = artifacts.require("./DaohausHub.sol");

contract('DaohausHub', function(accounts) {

  let daohausHub;

  assert.isAtLeast(accounts.length, 3);
  account0 = accounts[0];
  account1 = accounts[1];
  account2 = accounts[2];

  before("should prepare", function() {
    return DaohausHub.new()
      .then(instance => daohausHub = instance)
  });

  describe("register", function() {
    it("should not be possible to register with 0 weis", function() {
      return expectedExceptionPromise(
          () => daohausHub.register({ from: account0, gas: 3000000, value: 0 }),
          3000000);
    });
  });
});
