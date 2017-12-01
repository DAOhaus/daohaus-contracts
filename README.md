This repo is a stand alone repo for the governance contracts associated with this project.  In order to view and interact with them, clone and run the [Daohaus-frontend](https://github.com/Daohaus/daohaus-frontend) repo as a sibling repository.  Getting started instructions found in the [README](https://github.com/Daohaus/daohaus-frontend) of that repo.


## TODO

- [ ] create Benevolent Dictator hub contract for use inside consensys
- [ ] Refactor tests that are meant to "throw" to follow pattern that won't break ganache - http://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
- [ ] check to make sure user isn't already member of hub before allowing to register
- [ ] check to make sure resource proposal isn't finished before allowing to vote -- currently can vote on finished proposals
- [ ] check if member of hub before allowing to vote
