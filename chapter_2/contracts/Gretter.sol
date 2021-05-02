// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Greeter is Ownable {
  string private _greeting = "Hello, World!";

  // 以下の関数や修飾子はopenzeppelinによって提供されている
  // address private _owner;

  // constructor() public {
  //   _owner = msg.sender;
  // }

  // modifier onlyOwner() {
  //   require(msg.sender == _owner, "Ownable: caller is not the owner");
  //   _;
  // }

  // function owner() public view returns (address) {
  //   return _owner;
  // }

  function greet() external view returns (string memory) {
    return _greeting;
  }

  function setGreeting(string calldata greeting) external onlyOwner {
    _greeting = greeting;
  }
}
