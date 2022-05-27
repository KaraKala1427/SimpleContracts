// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Split {
  address public owner;
  mapping(address => uint) public balances;
  event Sent(address from, address receiver1, address receiver2, 
    address receiver3, uint amount);

  constructor() public{
    owner = msg.sender;
  }

  function coin(address receiver, uint amount) public {
    require(msg.sender == owner, "Access denied!");
    require(amount < 1e60, "Very big amount");
    balances[receiver] += amount;
  }

  function send(uint amount, address receiver1, address receiver2, address receiver3) public {
    require(amount <= balances[msg.sender], "Insufficient funds");
    balances[msg.sender] -= amount;
    balances[receiver1] += amount/3;
    balances[receiver2] += amount/3;
    balances[receiver3] += amount/3;

    emit Sent(msg.sender, receiver1, receiver2, receiver3, amount);
  }
}
