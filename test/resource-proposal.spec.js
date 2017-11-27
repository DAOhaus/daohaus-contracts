const expectedExceptionPromise = require("../utils/expectedException.js");
web3.eth.getTransactionReceiptMined = require("../utils/getTransactionReceiptMined.js");
Promise = require("bluebird");
Promise.allNamed = require("../utils/sequentialPromiseNamed.js");
const randomIntIn = require("../utils/randomIntIn.js");
const toBytes32 = require("../utils/toBytes32.js");

if (typeof web3.eth.getAccountsPromise === "undefined") {
    Promise.promisifyAll(web3.eth, { suffix: "Promise" });
}

const Hub = artifacts.require("./Hub.sol");
const Proposal = artifacts.require("./ResourceProposal.sol");

contract('Proposal', function(accounts) {

  let proposal;
  const proposalText = 'simple test'

  assert.isAtLeast(accounts.length, 3);
  account0 = accounts[0];
  account1 = accounts[1];
  account2 = accounts[2];

  before("should prepare", function() {
    return Proposal.new(account1, 25,10,5,proposalText)
    .then(inst => proposal = inst)
  });

  describe("register", function () {
    it("should have matching proposal text", function () {
      return proposal.proposalText()
        .then(_text => {
          assert.strictEqual(_text, proposalText);
        })
    });
  })
});
