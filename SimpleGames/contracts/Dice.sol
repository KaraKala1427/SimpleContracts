// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Dice {
  address public manager;
  address payable[] public players;
  function CEO() public {
    manager = msg.sender;
  }

  function Enter() public payable returns (uint) {
    require(msg.value > 0.001 ether, "Funds are too low");
    players.push(payable(msg.sender));
  }

  function getRandomNumber( uint number) private view returns (uint) {
    uint brosok  = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, number))) % 10;
    brosok = brosok + 2;
    return(brosok);
  }

  function Winner() public payable restricted returns(string memory, uint, uint) {
    uint player1 = getRandomNumber(0);
    uint player2 = getRandomNumber(1);
    if(player1 > player2) {
      players[0].transfer(address(this).balance) ;
      return("Winner is player 1: ",player1, player2);
    }
    else if(player1 < player2){
      players[1].transfer(address(this).balance );
      return("Winner is player 2: ", player1, player2);
    }
    else return("Draw, your bets are burned", player1, player2);
  }

  modifier restricted() {
    require(msg.sender == manager, "No access");
    _;
  } 
}
