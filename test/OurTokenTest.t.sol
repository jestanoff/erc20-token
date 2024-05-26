// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
  OurToken public ourToken;
  DeployOurToken public deployer;

  address bob = makeAddr("bob");
  address alice = makeAddr("alice");

  uint256 public constant STARTING_BALANCE = 100 ether;

  function setUp() public {
    deployer = new DeployOurToken();
    ourToken = deployer.run();
    /*
      TestContract msg.sender 0x1804...1f38 is Forge Test runner address
      TestContract address(this) 0x7FA9...1496

      DeployScriptContract msg.sender 0x7FA9...1496 is TestContract address
      DeployScriptContract address(this) 0x5615...b72f

      TokenContract msg.sender 0x1804...1f38 is Forge Test runner address
      TokenContract address(this) 0x9019...98A1
    */
    // vm.prank is set to be the test runner in this case
    vm.prank(msg.sender);
    ourToken.transfer(bob, STARTING_BALANCE);
  }

  function testBobBalance() public view {
    assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
  }

  function testAllowancesWorks() public {
    uint256 initialAllowance = 1000;

    // Bob approves Alice to spend tokens on her behalf
    vm.prank(bob);
    ourToken.approve(alice, initialAllowance);

    uint256 transferAmount = 500;

    vm.prank(alice);
    ourToken.transferFrom(bob, alice, transferAmount);

    assertEq(ourToken.balanceOf(alice), transferAmount);
    assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
  }

  function testTransfer() public {
    uint256 transferAmount = 50 ether;
    vm.prank(bob);
    ourToken.transfer(alice, transferAmount);
    assertEq(ourToken.balanceOf(alice), transferAmount);
    assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
  }
}