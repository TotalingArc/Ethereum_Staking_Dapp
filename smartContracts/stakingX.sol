// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Staking {
    address public owner;

    struct Position {
        uint positionId;
        address walletAddress;
        uint creationDate;
        uint unlockDate;
        uint percentInterest;
        uint weiStaked;
        uint weiInterest;
        bool open;
    }

    uint public currentPositionId;
    mapping(uint => Position) public positions;
    mapping(address => uint[]) public positionIdsByAddress;
    uint[] public lockPeriods = [0, 30, 60, 90];
    mapping(uint => uint) public tiers;

    constructor() payable {
        owner = msg.sender;
        currentPositionId = 0;

        tiers[0] = 700;
        tiers[30] = 800;
        tiers[60] = 900;
        tiers[90] = 1200;
    }

    function stakeEther(uint numDays) external payable {
        require(tiers[numDays] > 0, "Invalid lock period");

        uint unlockDate = block.timestamp + (numDays * 1 days);
        uint interest = calculateInterest(tiers[numDays], msg.value);

        positions[currentPositionId] = Position(
            currentPositionId,
            msg.sender,
            block.timestamp,
            unlockDate,
            tiers[numDays],
            msg.value,
            interest,
            true
        );

        positionIdsByAddress[msg.sender].push(currentPositionId);
        currentPositionId++;
    }

    function calculateInterest(uint basisPoints, uint weiAmount) private pure returns(uint) {
        return basisPoints * weiAmount / 10000;
    }

    function closePosition(uint positionId) external {
        Position storage position = positions[positionId];
        require(position.walletAddress == msg.sender, "Only position creator may modify position");
        require(position.open, "Position is closed");
        require(block.timestamp >= position.unlockDate, "Position is still locked");

        position.open = false;
        uint amount = position.weiStaked + position.weiInterest;
        payable(msg.sender).transfer(amount);
    }

    function getPositionById(uint positionId) external view returns(Position memory) {
        return positions[positionId];
    }

    function getPositionIdsForAddress(address walletAddress) external view returns(uint[] memory) {
        return positionIdsByAddress[walletAddress];
    }
}
