require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: process.env.GOERLI_URL, // Testnet endpoint from Infura or Alchemy
      accounts: [process.env.PRIVATE_KEY], // Your deployer account's private key
    },
  },
};
