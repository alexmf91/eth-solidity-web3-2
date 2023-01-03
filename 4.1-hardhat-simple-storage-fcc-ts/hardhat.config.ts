import("@nomiclabs/hardhat-waffle")
import("hardhat-gas-reporter")
import("./tasks/block-number")
import("@nomiclabs/hardhat-etherscan")
import { task, HardhatUserConfig } from "hardhat/config"
import "./tasks/block-number"
import "dotenv/config"
import "solidity-coverage"
// This package is to get contract types properly
import "@typechain/hardhat"
import "@nomiclabs/hardhat-ethers"

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""
const GOERLI_RPC_URL =
  process.env.GOERLI_RPC_URL ||
  "https://eth-goerli.alchemyapi.io/v2/your-api-key"
const PRIVATE_KEY =
  process.env.PRIVATE_KEY ||
  "0x11ee3108a03081fe260ecdc106554d09d9d1209bcafd46942b10e02943effc4a"
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    rinkeby: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 4,
    },
  },
  solidity: "0.8.7",
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    coinmarketcap: COINMARKETCAP_API_KEY,
  },
}

export default config
