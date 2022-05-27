// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SafeMath.sol";

contract BankDeposit {
  using SafeMath for uint;
  mapping(address => uint) public userDeposit;
  mapping(address => uint) public balance;
  mapping(address => uint) public time;
  mapping(address => uint) public percentWithdraw;
  mapping(address => uint) public allPercentWithdraw;

  uint public stepTime = 0.05 hours;

  event Invest(address investor, uint256 amount);
  event Withdraw(address investor, uint256 amount);

  modifier userExist(){
    require(balance[msg.sender] > 0, "User not found");
    _;
  }

  modifier checkTime(){
    require(block.timestamp >= time[msg.sender].add(stepTime), "Not enough time gone");
    _;
  }

  function bankAccount() public payable{
    require(msg.value >= .001 ether);
  }

  //для выплаты процентов по вкладу
  function collectPercent() userExist checkTime public {
    if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender]) {
        balance[msg.sender] = 0;
        time[msg.sender] = 0;
        percentWithdraw[msg.sender] = 0;
    } else {
      uint payout = payoutAmount(); // рассчитывается сумма к выплате
      percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
      allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
      payable(msg.sender).transfer(payout);
      emit Withdraw(msg.sender, payout);
    } 
  }

  //для внесения депозита
  function deposit() public payable {
    if(msg.value > 0) {
      if(balance[msg.sender] > 0 && block.timestamp > time[msg.sender].add(stepTime)) {
        collectPercent();
        percentWithdraw[msg.sender] = 0;
      }
      balance[msg.sender] = balance[msg.sender].add(msg.value);
      time[msg.sender] = block.timestamp;
      emit Invest(msg.sender, msg.value);
    }
  }

  function percentRate() public view returns(uint) {
    if(balance[msg.sender] < 10 ether) {
      return (5);
    }
    if(balance[msg.sender] >= 10 ether && balance[msg.sender] < 20 ether) {
      return (7);
    }
    if(balance[msg.sender] >= 20 ether && balance[msg.sender] < 30 ether) {
      return (8);
    }
    if(balance[msg.sender] >= 30 ether) {
      return (9);
    }
  }

  // рассчитывается сумма к выплате
  function payoutAmount() public view returns (uint256) {
    uint percent = percentRate();
    uint diffenerent = block.timestamp.sub(time[msg.sender]).div(stepTime);
    uint rate = balance[msg.sender].div(100).mul(percent);
    uint withdrawalAmount = rate.mul(diffenerent).sub(percentWithdraw[msg.sender]);
    return withdrawalAmount;
  }

  //возвращает первоначально положенный депозит
  function returnDeposit() public {
    uint withdrawalAmount = balance[msg.sender];
    balance[msg.sender] = 0;
    time[msg.sender] = 0;
    percentWithdraw[msg.sender] = 0;
    payable(msg.sender).transfer(withdrawalAmount);
  }
}
