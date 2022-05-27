// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Note {
  struct user{
    string name;
    uint number;
    string adress;  
  }
  
  mapping(string => user) public users;

  function setUser(string memory name, uint number, string memory adress) public{
    users[name] = user(name, number, adress);
  }

  function getUser(string memory name) public view returns (uint number, string memory adress){
    return (users[name].number, users[name].adress);
  }

}
