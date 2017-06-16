const HausToken = artifacts.require("./HausToken.sol");
const BN = require('../node_modules/bn.js');

contract('HausToken', (accounts) => {
  it('should initialize value to 0', () => {
    return HausToken.deployed().then((instance) => {
      // return instance.get();
      return instance.value();
    }).then((value) => {
      assert(value.isZero(), 'value should be initialized to zero.');
    });
  });

  it('should set the value to what I tell it to', () => {
    let haus;

    return HausToken.deployed().then((instance) => {
      haus = instance;
      return haus.set(new BN(5));
    }).then(() => {
      return haus.get();
    }).then((value) => {
      assert.isFalse(value.isZero(), 'value should not be zero.');
      assert(value.eq(new BN(5)), 'value should be five');
    });
  });
});