const MyOracle = artifacts.require("../contracts/HausToken.sol");
const BN = require('../node_modules/bn.js');

contract('MyOracle', (accounts) => {
  it('should initialize value to 0', () => {
    return MyOracle.deployed().then((instance) => {
      // return instance.get();
      return instance.value();
    }).then((value) => {
      assert(value.isZero(), 'value should be initialized to zero.');
    });
  });

  it('should set the value to what I tell it to', () => {
    let oracle;

    return MyOracle.deployed().then((instance) => {
      oracle = instance;
      return oracle.set(new BN(5));
    }).then(() => {
      return oracle.get();
    }).then((value) => {
      assert.isFalse(value.isZero(), 'value should not be zero.');
      assert(value.eq(new BN(5)), 'value should be five');
    });
  });
});