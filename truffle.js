module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    }
  },
  compiler: {
   version: "0.4.15",
   optimization: false
 }
};
