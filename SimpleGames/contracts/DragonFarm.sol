// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract DragonFarm {
  event NewDragon(uint id, string name, uint dna);
  struct Dragon{
    uint id;
    string name;
    uint dna;
  }

  Dragon[] public dragons;
  mapping (uint => address) public DragonOwner;
  mapping (address => uint) ownerDragons;
  function generateRandomDna(string memory str) internal pure returns (uint){
    uint rand = uint(keccak256(abi.encode(str)));
    return rand % (10 ** 16);
  }

  function CreateDragon(string memory name) public {
    uint dna = generateRandomDna(name);
    uint id = ownerDragons[msg.sender];
    dragons.push(Dragon(id, name, dna));
    DragonOwner[id] = msg.sender;
    emit NewDragon(id, name, dna);
    ownerDragons[msg.sender]++;
  }
}
