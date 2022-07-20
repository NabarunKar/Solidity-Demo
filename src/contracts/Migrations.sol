// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
  address public owner = msg.sender; // current caller, us
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _; // continue running the function if require passes
  }

  function setCompleted(uint completed) public restricted { // keeps track of completions
    last_completed_migration = completed;
  }

  // function to allow us to upgrade our migrations
  function upgrade(address new_address) public restricted { // restricted -> can only be used by msg.sender
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
