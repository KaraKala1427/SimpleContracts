// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Voter {
  struct Candidate{
    uint id;
    string name;
    uint totalVotes;
  }

//Используем mapping для хранения массива проголосовавших адресов, назовем его voters.
  mapping(address => bool) private voters;
  mapping (uint => Candidate) public candidates;
  uint private Count;

  event votedEvent (
    uint indexed candidateId
  );

  function addCandidate(string memory new_name) public {
    Count ++;
    candidates[Count] = Candidate(Count, new_name, 0);
  }

  function vote (uint candidateId) public {
    require(!voters[msg.sender]); //условие, что человек еще не голосовал
    require(candidateId > 0 && candidateId <= Count);

    voters[msg.sender] = true;
    candidates[candidateId].totalVotes ++;
    emit votedEvent(candidateId);
  }

}
