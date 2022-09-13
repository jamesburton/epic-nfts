import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import '@nomicfoundation/hardhat-chai-matchers';
import '@nomiclabs/hardhat-ethers';

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY].filter(Boolean) as string[]
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY].filter(Boolean) as string[]
    },
    rinkeby: {
      // url: ``process.env.QUICKNODE_API_KEY_URL,
      // accounts: [process.env.RINKEBY_PRIVATE_KEY],
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY].filter(Boolean) as string[]
    },
    ropstein: {
      url: `https://ropstein.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY].filter(Boolean) as string[]
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY].filter(Boolean) as string[]
    },
    // aurora: {},
    // [aurora-test]: {},
  },
};

export default config;
