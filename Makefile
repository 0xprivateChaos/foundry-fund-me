-include .env

# To write both commands in a single line use semicolon(;)

build:; forge build

# If we are writing commands in different line no need to use semicolon

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1