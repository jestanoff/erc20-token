// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken {
  mapping(address => uint256) private s_balances;

  string public name = "Manual Token";

  function totalSupply() public pure returns (uint256) {
    return 100 ether; // 100 * 10^18 or 1_000_000_000_000_000_000
  }

  function decimals() public pure returns (uint8) {
    return 18;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return s_balances[_owner];
  }

  function transfer(address _to, uint256 amount) public returns (bool success){
    uint256 previousCombaniedBalances = s_balances[msg.sender] + s_balances[_to];
    s_balances[msg.sender] -= amount;
    s_balances[_to] += amount;

    require(previousCombaniedBalances == s_balances[msg.sender] + s_balances[_to], 'Transfer failed');
    return true;
  }
}
