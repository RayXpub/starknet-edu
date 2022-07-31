import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const GOERLI_ENDPOINT = `https://goerli.infura.io/v3/${process.env.INFURA_TOKEN}`;
const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1
  ? process.env.PRIVATE_KEY_1
  : "";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: GOERLI_ENDPOINT,
      chainId: 5,
      accounts: [PRIVATE_KEY_1],
    },
  },
};

export default config;
