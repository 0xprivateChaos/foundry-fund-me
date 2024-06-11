# Fund Contract README

## Overview
This project is a smart contract written in Solidity for collecting funds. Anyone can contribute funds above a minimum amount of 5 USD. Only the owner of the contract has the authority to withdraw the collected funds at any time. The contract keeps track of all funders and resets their balances to zero upon withdrawal.

## Features
1. Minimum Funding Amount: The contract enforces a minimum funding amount of 5 USD.
2. Ownership Control: Only the contract owner can withdraw funds.
3. Funder Tracking: The contract maintains a record of all funders and their respective balances.
4. Balance Reset: Upon withdrawal by the owner, all funder balances are reset to zero.
   
## Contract Details
1. Language: Solidity
2. Deployment: The contract can be deployed using scripts written in Foundry.
3. Testing: Comprehensive tests have been written to ensure contract functionality.
   
# Setup
  ### Prerequisites
   1. Foundry installed
   2. Solidity compiler
   
  ### Quickstart
  ```sh
  git clone https://github.com/Aman09-Jat/foundry-fund-me.git
  cd foundry-fund-me
  forge build
  ```

## Usage
  ### Deploy
  ```
  forge script script/DeployFundMe.s.sol
  ```
  ### Testing
  ```
  forge test
  ```
  or
  ```
  // Only run test functions matching the specified regex pattern.
  forge test --match-test testFunctionName
  ```
  or
  ```
  forge test --fork-url $SEPOLIA_RPC_URL
  ```
  ### Test Coverage
  ```
  forge coverage
  ```

# Deployment to a testnet or mainnet

1. Setup environment variables<br/>
   You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file.
   <br/>
   Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).
2. Get testnet ETH<br/>
   Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.
3. Deploy<br/>
   ```sh
   forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
   ```

## Scripts
After deploying to a testnet or local net, you can run the scripts.<br/><br/>
Using cast deployed locally example:
```sh
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```
or 
```sh
forge script script/Interactions.s.sol:FundFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```
### Withdraw
```sh
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```

## Estimate gas
You can estimate how much gas things cost by running:
```sh
forge snapshot
```
And you'll see an output file called `.gas-snapshot`

# Thank you!
