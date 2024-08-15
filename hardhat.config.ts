import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import "@openzeppelin/hardhat-upgrades"

import dotenv from 'dotenv';

dotenv.config();


const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [`0x${process.env.DEPLOYER_PRIV}`],
      gasPrice: "auto",
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [`0x${process.env.DEPLOYER_PRIV}`],
      gasPrice: "auto",
    },
  },
  etherscan: {
    apiKey: process.env.SCAN_APIKEY,
  },
};

export default config;
