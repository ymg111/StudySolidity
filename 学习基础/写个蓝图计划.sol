 // SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  

contract BluePlan {

    // 每秒产出利息
    uint public interest;
    address public rewardToken;
    address public owner;
    address[] public rewarduser;
    
    struct User{
        uint userReward;
        bool userstate;
    }

    mapping(address => User) public User_Map;

    constructor (uint _interest, address _rewardToken) {
        interest = _interest;
        rewardToken = _rewardToken;
        owner = msg.sender;
    }

    function SetReward(address[] memory _rewarduser) public returns (address[] memory) {
        rewarduser = _rewarduser;

    }

    function returnArray() public returns (address[] memory) {
        return rewarduser;
    }




}