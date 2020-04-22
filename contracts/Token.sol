pragma solidity 0.5.2;

import '@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol';

contract Token is ERC20Mintable {
  string public name = "Demo RSK Token";
  string public symbol = "DEMO";
  uint8 public decimals = 2;
}
