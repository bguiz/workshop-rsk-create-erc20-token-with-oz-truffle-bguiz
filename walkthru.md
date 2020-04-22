# RSK workshop - Walkthrough - Create an ERC20 token with OpenZeppelin and Truffle

## Pre-requisites

You should have the following software installed on your system:

- `node` & `npm`
- any code editor, preferably one with support for syntax highlighting of Solidity and Javascript
- `curl`
- `git`

Check that you are able to connect to the RSK public node,
using a direct JSON-RPC request over HTTP:

```shell
curl \
  https://public-node.testnet.rsk.co/1.3.0/ \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

## Part 1 - Development

Create a new project folder

```shell
mkdir -p workshop-rsk-create-erc20-token-with-oz-truffle-bguiz
cd workshop-rsk-create-erc20-token-with-oz-truffle-bguiz
git init
node -v
npm -v
npm i -g truffle@5.1.22

```

Initialise truffle in the folder

```shell
truffle init
git add truffle-config.js migrations/ contracts/
git commit -m "step: 01-01: truffle init"

```

Initialise npm module in the folder

```shell
npm init
git add package.json
code package.json
git commit -m "step: 01-02: npm init"

```

Install npm dependencies

```shell
npm i --save @openzeppelin/contracts@3.0.0 @truffle/hdwallet-provider@1.0.34
git add -p
git commit -m "step: 01-03: npm install"

```

Tell git to ignore the installed dependencies folder

```shell
echo "/node_modules" >> .gitignore
git add .gitignore
git commit -m "step: 01-04: .gitignore"

```

Generate a 12-word BIP39 mnemonic using [iancoleman.io/bip39](https://iancoleman.io/bip39/)

```shell
# https://iancoleman.io/bip39/
echo "panther runway humor wife devote crane spawn tuition shaft present open thank" > .secret
git add .secret
git commit -m "step: 02-01: add .secret - NOTE do not actually do this for real projects, this is just for demo purposes only"

```

Check that there are no problems running compiler via Truffle

```shell
truffle compile
# check that there are no problems running compiler
```

```javascript
const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

```

Modify the Truffle config so that we can do the following:

- Use a hierarchically deterministic wallet with a BIP39 mnemonic
- Configure it to connect to the RSK Testnet
- Use a particular version of the Solidity compiler

```shell
code truffle-config.js
```

```javascript
  networks: {
    testnet: {
      provider: () => new HDWalletProvider(
        mnemonic,
        'https://public-node.testnet.rsk.co/1.3.0/',
      ),
      network_id: 31,
      gasPrice: 0x387EE40,
      networkCheckTimeout: 1000000000
    },
    // ...
  },

```

```javascript
  compilers: {
    solc: {
      version: '0.5.2',
      // ...
    },
  },

```

```shell
truffle console --network testnet
```

Wait for a few seconds, and you should see a prompt which looks like:
`truffle(testnet)> `.
Test that the connection is OK by attempting to get the block number, like so:

```javascript
(await web3.eth.getBlockNumber()).toString()
'791905'

```

```javascript
Object.keys(web3.currentProvider.wallets)[0]
Object.keys(web3.currentProvider.wallets)[1]
Object.keys(web3.currentProvider.wallets)[2]

```

Type `.exit` to quit the Truffle console.

```shell
git add -p truffle-config.js
git commit -m "step: 02-02: edit truffle config to use HD wallet and add RSK testnet"

```

```shell
echo 0xec9d8134670d9d59635303a585f36749035dc9d5 >> .accounts
echo 0x04a447e82c4f3cc74baf1cc97f9987ef2771b181 >> .accounts
echo 0xe1c6e5dbe2893ede2b95d78547a4ff5c4b94145b >> .accounts
git add .accounts
git commit .accounts -m "step: 02-03: out list of account addresses"
```

```shell
npm i --save @openzeppelin/contracts@2.5.0
git add package.json
git commit -m "step: 02-04: use older version of OZ contracts"

```

```shell
touch contracts/Token.sol
code contracts/Token.sol
```

```solidity
pragma solidity 0.5.2;

import '@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol';

contract Token is ERC20Mintable {
  string public name = "Demo RSK Token";
  string public symbol = "DEMO";
  uint8 public decimals = 2;
}

```

```shell
truffle compile
git add contracts/Token.sol
git commit contracts/Token.sol -m "step: 03-01: create Token contract"
```

```shell
touch migrations/2_deploy_contracts.js
code migrations/2_deploy_contracts.js
```

```javascript
const Token = artifacts.require("Token");

module.exports = function(deployer) {
  deployer.deploy(Token);
};

```

```shell
git add migrations/2_deploy_contracts.js
git commit migrations/2_deploy_contracts.js -m "step: 03-02: create Token deploy script"

```

```shell
truffle migrate --network testnet
# wait for very long
# copy contract address

```

```shell
echo '0xE27D250844A28C81f37a55eED68001E34D727E44' >> .token
git add .token
git commit .token -m "step: 03-03: save Token deployed address for future reference"

```

```shell
jq '.networks."31".address' < build/contracts/Token.json
# note that truffle does this for us anyway, in its build output

```

```shell
git add build/contracts/
git commit -m "step: 03-04: truffle build output - NOTE this does not need to be comitted, for demonstration purposes"
```


## Part 2 - Interactions

Now that we have our contract deployed on the RSK Testnet,
let us interact with it on from the truffle console.
We will be submitting transactions which invoke the
the `mint` and `transfer` functions.

```shell
$ truffle console --network testnet
```

Now you're in a REPL, so you prompt will change,
each line will now start with `truffle(testnet)> `
instead of your usual prompt.

```javascript
const token = await Token.deployed()
undefined
```

```javascript
const accounts = await web3.eth.getAccounts()
undefined
```

```javascript
token.
token.__defineGetter__      token.__defineSetter__      token.__lookupGetter__      token.__lookupSetter__      token.__proto__
token.hasOwnProperty        token.isPrototypeOf         token.propertyIsEnumerable  token.toLocaleString        token.toString
token.valueOf

token.Approval              token.MinterAdded           token.MinterRemoved         token.Transfer              token.abi
token.addMinter             token.address               token.allEvents             token.allowance             token.approve
token.balanceOf             token.constructor           token.contract              token.decimals              token.decreaseAllowance
token.getPastEvents         token.increaseAllowance     token.isMinter              token.methods               token.mint
token.name                  token.renounceMinter        token.send                  token.sendTransaction       token.symbol
token.totalSupply           token.transactionHash       token.transfer              token.transferFrom
```

```javascript
(await token.totalSupply()).toString()
'0'
```

```javascript
(await token.balanceOf(accounts[0])).toString()
'0'
```

```javascript
mintTxInfo = (await token.mint(accounts[0], 10000))
undefined

mintTxInfo
{
  tx: '0x260755c3a8d76b8797fb617bec13937a7e5f19723a594a8187fc1ab04e4a1163',
  receipt: {
    transactionHash: '0x260755c3a8d76b8797fb617bec13937a7e5f19723a594a8187fc1ab04e4a1163',
    transactionIndex: 1,
    blockHash: '0x76c4ad7c5cae2471b457dd771bec74641397b3f5dcb6708e11fd1077024342ee',
    blockNumber: 791830,
    cumulativeGasUsed: 120952,
    gasUsed: 66659,
    contractAddress: null,
    logs: [ [Object] ],
    from: '0xec9d8134670d9d59635303a585f36749035dc9d5',
    to: '0xe27d250844a28c81f37a55eed68001e34d727e44',
    root: '0x01',
    status: true,
    logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000020000000000000000000800000000000000001000000010000000000000000000000000000000000000000000000000000010000000000008000000000000000000000000000000000000000000000000000000000000000000000000400002080000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000080000000000000000000000000',
    rawLogs: [ [Object] ]
  },
  logs: [
    {
      logIndex: 0,
      blockNumber: 791830,
      blockHash: '0x76c4ad7c5cae2471b457dd771bec74641397b3f5dcb6708e11fd1077024342ee',
      transactionHash: '0x260755c3a8d76b8797fb617bec13937a7e5f19723a594a8187fc1ab04e4a1163',
      transactionIndex: 1,
      address: '0xE27D250844A28C81f37a55eED68001E34D727E44',
      id: 'log_4aae479b',
      event: 'Transfer',
      args: [Result]
    }
  ]
}
```


After the mint action is performed, on this token smart contract:

- View transactions: https://explorer.testnet.rsk.co/address/0xe27d250844a28c81f37a55eed68001e34d727e44?__tab=transactions
- View accounts: https://explorer.testnet.rsk.co/address/0xe27d250844a28c81f37a55eed68001e34d727e44?__tab=accounts

(substitute contract address in URLs with your own)

```javascript
(await token.totalSupply()).toString()
'10000'
```

```javascript
(await token.balanceOf(accounts[0])).toString()
'10000'
```

transferTxInfo = await token.transfer(accounts[1], 5, { from: accounts[0] })
undefined

transferTxInfo
{
  tx: '0x567685c8ee340ea5723de9ceacec39169e9cf9c797a3f13afc1c4c20b7a22def',
  receipt: {
    transactionHash: '0x567685c8ee340ea5723de9ceacec39169e9cf9c797a3f13afc1c4c20b7a22def',
    transactionIndex: 0,
    blockHash: '0x037203e2126b099edb57db2b33b656132987bcaf6be9ec4d97dc2c31aa2f78c6',
    blockNumber: 791839,
    cumulativeGasUsed: 51356,
    gasUsed: 51356,
    contractAddress: null,
    logs: [ [Object] ],
    from: '0xec9d8134670d9d59635303a585f36749035dc9d5',
    to: '0xe27d250844a28c81f37a55eed68001e34d727e44',
    root: '0x01',
    status: true,
    logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000400000000000000000000000000000000000000001000000010000000000000000000000000000000000000000000000004000010000000000008000000000000000000000000000000000000000000000000000000000000000000000000400002080000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000080000000000000000000000000',
    rawLogs: [ [Object] ]
  },
  logs: [
    {
      logIndex: 0,
      blockNumber: 791839,
      blockHash: '0x037203e2126b099edb57db2b33b656132987bcaf6be9ec4d97dc2c31aa2f78c6',
      transactionHash: '0x567685c8ee340ea5723de9ceacec39169e9cf9c797a3f13afc1c4c20b7a22def',
      transactionIndex: 0,
      address: '0xE27D250844A28C81f37a55eED68001E34D727E44',
      id: 'log_6e53bab0',
      event: 'Transfer',
      args: [Result]
    }
  ]
}


After the mint action is performed, on this token smart contract:

- View transactions: https://explorer.testnet.rsk.co/address/0xe27d250844a28c81f37a55eed68001e34d727e44?__tab=transactions
  - There should be 2 transactions now, one for the mint from before,
    and one for the transfer
- View accounts: https://explorer.testnet.rsk.co/address/0xe27d250844a28c81f37a55eed68001e34d727e44?__tab=accounts
  - There should be 2 accounts with non-zero balances:
    `account[0]` has a large amount and `account[1]` has a small amount
  - Sum of their amounts should equal to the total supply

(substitute contract address in URLs with your own)

## Conclusion

We are done!

Where to go from here?

- Write a front end for your smart contract
- Interact with your smart contract via `geth` instead of Truffle console
- Add more functions to your smart contract
- Write tests for your smart contract
