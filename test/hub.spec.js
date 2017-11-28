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

const Hub = artifacts.require("./Hub.sol");
const ResourceProposal = artifacts.require("./ResourceProposal.sol");

contract('Hub', function(accounts) {

  let hub;

  assert.isAtLeast(accounts.length, 3);
  account0 = accounts[0];
  memberOne = accounts[1];
  memberTwo = accounts[2];
  memberThree = accounts[3];
  chairMan = accounts[4];

  beforeEach("should prepare", function() {
    return Hub.new()
      .then(instance => hub = instance)
  });

  describe("register", function() {
    it("should not be possible to register with 0 weis", function() {
      return expectedExceptionPromise(
          () => hub.register("+91000", "A" , { from: account0, gas: 3000000, value: 0 }),
          3000000);
    });
    it("should be possible to register with > 0 weis", function() {
      return hub.register("+91000", "B", { from: account0, gas: 3000000, value: 1000 })
      .then(tx => {
        assert.strictEqual(tx.receipt.logs.length, 1);
        assert.strictEqual(tx.logs.length, 1);
        const logEntered = tx.logs[0];
        //console.log(logEntered.args.phoneNumber);
        assert.strictEqual(logEntered.event, "LogMemberRegistered");
        assert.strictEqual(logEntered.args.member, account0);
        assert.strictEqual(logEntered.args.ethPledge.toNumber(), 1000);
        assert.strictEqual(logEntered.args._availableBalance.toNumber(), 1000);
        assert.strictEqual(logEntered.args._runningBalance.toNumber(), 1000);
        return hub.getMembersCount();
      })
      .then(membersCount => {
        assert.strictEqual(membersCount.toNumber(), 1);
        return hub.getVotingRightRatio(account0);
      })
      .then(votingRightRatio => {
        assert.strictEqual(votingRightRatio.toNumber(), 100);
      });
    });
    it("should be able to create resource proposal", function() {
      let proposalAddress;
      let proposalContract;

      const proposal = {
        chairmanAddress: chairMan,
        fees: 10,
        blocks: 2,
        cost: 5,
        text: "Buy a carton of eggs"
      };

      return hub.register("+91000","C", { from: memberOne, gas: 3000000, value: 10 })
      .then(tx => {
        assert.strictEqual(tx.receipt.logs.length, 1);
        assert.strictEqual(tx.logs.length, 1);
        const logEntered = tx.logs[0];
        assert.strictEqual(logEntered.event, "LogMemberRegistered");
        assert.strictEqual(logEntered.args.member, memberOne);
        assert.strictEqual(logEntered.args.ethPledge.toNumber(), 10);
        assert.strictEqual(logEntered.args._availableBalance.toNumber(), 10);
        assert.strictEqual(logEntered.args._runningBalance.toNumber(), 10);
        return;
      })
      .then(() => {
        return hub.register("+162671","D", { from: account0, gas: 3000000, value: 1000 })
      })
      .then(() => {
        return hub.register("+162671", "E",  { from: memberTwo, gas: 3000000, value: 10 })
      })
      .then(() => {
        return hub.register("+32323", "F", { from: memberThree, gas: 3000000, value: 10 })
      })
      .then(() => {
        return hub.register("+372838", "G",  { from: chairMan, gas: 3000000, value: 10 })
      })
      .then(() => {
        return hub.getMembersCount();
      })
      .then(membersCount => {
        assert.strictEqual(membersCount.toNumber(), 5);
        return hub.createResourceProposal(
          proposal.chairmanAddress,
          proposal.fees,
          proposal.blocks,
          proposal.cost,
          proposal.text,
          { from: account0 }
        );
      })
      .then(tx => {
        assert.strictEqual(tx.receipt.logs.length, 1);
        assert.strictEqual(tx.logs.length, 1);
        const logEntered = tx.logs[0];
        assert.strictEqual(logEntered.event, "LogNewProposal");
        assert.strictEqual(logEntered.args.chairmanAddress, proposal.chairmanAddress);
        assert.strictEqual(logEntered.args.pid.toNumber(), 1);
        assert.strictEqual(logEntered.args.fees.toNumber(), proposal.fees);
        assert.strictEqual(logEntered.args.blocks.toNumber(), proposal.blocks);
        assert.strictEqual(logEntered.args.cost.toNumber(), proposal.cost);
        proposalAddress = logEntered.args.proposalAddress;
        return hub.getProposalCount();
      })
      .then(proposalCount => {
        assert.strictEqual(proposalCount.toNumber(), 1);
      })
      .then(() => {
        return ResourceProposal.at(proposalAddress);
      })
      .then(_proposal => {
        proposalContract = _proposal;
        return;
      })
      .then(() => {
        return proposalContract.castVote(1, { from: account0 })
      })
      .then(() => {
        return proposalContract.castVote(2, { from: memberOne })
      })
      .then(() => {
        return proposalContract.castVote(2, { from: memberTwo })
      })
      .then(() => {
        return proposalContract.castVote(2, { from: memberThree })
      })
      .then(() => {
        return proposalContract.castVote(2, { from: chairMan })
      })
      .then(() => {
        return proposalContract.sendToHub();
      })
      .then(() => {
        return proposalContract.getStatus();
      })
      .then(_status => {
        assert.strictEqual(_status.toNumber(), 1);
      })
    });
    describe('withdrawal', () => {
      it("charman should be able to withdraw", function() {
        let proposalAddress;
        let proposalContract;

        const proposal = {
          chairmanAddress: chairMan,
          fees: 10,
          blocks: 2,
          cost: 5,
          text: "Buy a carton of eggs"
        };

        return hub.register("+91000", "A", { from: memberOne, gas: 3000000, value: 10 })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
          const logEntered = tx.logs[0];
          assert.strictEqual(logEntered.event, "LogMemberRegistered");
          assert.strictEqual(logEntered.args.member, memberOne);
          assert.strictEqual(logEntered.args.ethPledge.toNumber(), 10);
          assert.strictEqual(logEntered.args._availableBalance.toNumber(), 10);
          assert.strictEqual(logEntered.args._runningBalance.toNumber(), 10);
          return;
        })
        .then(() => {
          return hub.register("+2323232", "F",  { from: account0, gas: 3000000, value: 1000 })
        })
        .then(() => {
          return hub.register("+162671", "W", { from: memberTwo, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+32323", "K", { from: memberThree, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+372838", "T", { from: chairMan, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.getMembersCount();
        })
        .then(membersCount => {
          assert.strictEqual(membersCount.toNumber(), 5);
          return hub.createResourceProposal(
            proposal.chairmanAddress,
            proposal.fees,
            proposal.blocks,
            proposal.cost,
            proposal.text,
            { from: account0 }
          );
        })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
          const logEntered = tx.logs[0];
          assert.strictEqual(logEntered.event, "LogNewProposal");
          assert.strictEqual(logEntered.args.chairmanAddress, proposal.chairmanAddress);
          assert.strictEqual(logEntered.args.fees.toNumber(), proposal.fees);
          assert.strictEqual(logEntered.args.blocks.toNumber(), proposal.blocks);
          assert.strictEqual(logEntered.args.cost.toNumber(), proposal.cost);
          proposalAddress = logEntered.args.proposalAddress;
          return hub.getProposalCount();
        })
        .then(proposalCount => {
          assert.strictEqual(proposalCount.toNumber(), 1);
        })
        .then(() => {
          return ResourceProposal.at(proposalAddress);
        })
        .then(_proposal => {
          proposalContract = _proposal;
          return;
        })
        .then(() => {
          return proposalContract.castVote(1, { from: account0 })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberOne })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberTwo })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberThree })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: chairMan })
        })
        .then(() => {
          return proposalContract.sendToHub();
        })
        .then(() => {
          return proposalContract.getStatus();
        })
        .then(_status => {
          assert.strictEqual(_status.toNumber(), 1);
        })
        .then(() => {
          return hub.withdraw({ from: chairMan });
        })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
          const logEntered = tx.logs[0];
          assert.strictEqual(logEntered.event, "LogChairmanWithdraw");
          assert.strictEqual(logEntered.args.amount.toNumber(), proposal.fees + proposal.cost);
        })
      });
      it("charman should not be able to withdraw", function() {
        let proposalAddress;
        let proposalContract;

        const proposal = {
          chairmanAddress: chairMan,
          fees: 10,
          blocks: 2,
          cost: 5,
          text: "Buy a carton of eggs"
        };

        return hub.register("+91000", "P", { from: memberOne, gas: 3000000, value: 10 })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
          const logEntered = tx.logs[0];
          assert.strictEqual(logEntered.event, "LogMemberRegistered");
          assert.strictEqual(logEntered.args.member, memberOne);
          assert.strictEqual(logEntered.args.ethPledge.toNumber(), 10);
          assert.strictEqual(logEntered.args._availableBalance.toNumber(), 10);
          assert.strictEqual(logEntered.args._runningBalance.toNumber(), 10);
          return;
        })
        .then(() => {
          return hub.register("+2323232", "Q", { from: account0, gas: 3000000, value: 1000 })
        })
        .then(() => {
          return hub.register("+162671","T", { from: memberTwo, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+32323","TT", { from: memberThree, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+372838","p", { from: chairMan, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.getMembersCount();
        })
        .then(membersCount => {
          assert.strictEqual(membersCount.toNumber(), 5);
          return hub.createResourceProposal(
            proposal.chairmanAddress,
            proposal.fees,
            proposal.blocks,
            proposal.cost,
            proposal.text,
            { from: account0 }
          );
        })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
          const logEntered = tx.logs[0];
          assert.strictEqual(logEntered.event, "LogNewProposal");
          assert.strictEqual(logEntered.args.chairmanAddress, proposal.chairmanAddress);
          assert.strictEqual(logEntered.args.fees.toNumber(), proposal.fees);
          assert.strictEqual(logEntered.args.blocks.toNumber(), proposal.blocks);
          assert.strictEqual(logEntered.args.cost.toNumber(), proposal.cost);
          proposalAddress = logEntered.args.proposalAddress;
          return hub.getProposalCount();
        })
        .then(proposalCount => {
          assert.strictEqual(proposalCount.toNumber(), 1);
        })
        .then(() => {
          return ResourceProposal.at(proposalAddress);
        })
        .then(_proposal => {
          proposalContract = _proposal;
          return;
        })
        .then(() => {
          return proposalContract.castVote(2, { from: account0 })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberOne })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberTwo })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: memberThree })
        })
        .then(() => {
          return proposalContract.castVote(2, { from: chairMan })
        })
        .then(() => {
          return proposalContract.sendToHub();
        })
        .then(() => {
          return proposalContract.getStatus();
        })
        .then(_status => {
          assert.strictEqual(_status.toNumber(), 2);
        })
        .then(() => {
          return expectedExceptionPromise(
              () => hub.withdraw({ from: chairMan, gas: 3000000}),
              3000000);
        })
      });
    });
    describe('get members', () => {
      it('should return an empty array', () => {
        return hub.getMembers()
          .then(_members => {
            assert.strictEqual(_members.length, 0);
          })
      });
    });

    /*describe('check NR proposal', () => {
      it('should create NR proposal', () => {
        let proposalAddress;
        let proposalContract;

        const proposal = {
          blocks: 2,
          val: 5,
          text: "change pvr"
        };

        return hub.register("+91000", "P", { from: memberOne, gas: 3000000, value: 10 })
        .then(() => {
          return hub.register("+162671","T", { from: memberTwo, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+32323","TT", { from: memberThree, gas: 3000000, value: 10 })
        })
        .then(() => {
          return hub.register("+372838","p", { from: chairMan, gas: 3000000, value: 10 })
        })
        .then(membersCount => {
          assert.strictEqual(membersCount.toNumber(), 4);
          return hub.createNonResourceProposal(
            proposal.val,
            proposal.blocks,
            proposal.text,
            { from: account0 }
          );
        })
        .then(tx => {
          assert.strictEqual(tx.receipt.logs.length, 1);
          assert.strictEqual(tx.logs.length, 1);
        });
      });
    });*/

  });
});
