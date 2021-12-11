//"SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  
  uint totalWaves;
  uint private seed;

  event NewWave(address indexed from, uint timestamp, string anime);

  struct Wave {
    address waver;
    string anime;
    uint timestamp;
  }

  Wave[] waves;
  mapping (address => uint) public lastWavedAt;

  constructor() payable {
    console.log("Smart contract - START!!!");

    seed = (block.timestamp + block.difficulty) % 100;
  }

  function wave(string calldata _anime) public {

    require(
      lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
      "Wait 15m"
    );

    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves++;
    waves.push(Wave(msg.sender, _anime, block.timestamp));
    console.log("Anime %s waved!", _anime);

    seed = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random # generated: %d", seed);

    if (seed  <= 50) {
      uint prizeAmount = 0.0001 ether;
      require(
        prizeAmount <= address(this).balance, 
        "Trying to withdraw more money than the contract has.");

      (bool success, ) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money from contract.");
    }

    emit NewWave(msg.sender, block.timestamp, _anime);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint) {
    console.log("We have %d total waves!", totalWaves);
    return totalWaves;
  }
}