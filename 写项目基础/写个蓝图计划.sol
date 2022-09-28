 // SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  
import "../safeMath/safemath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BluePlan {

    using SafeMath for uint;
    using SafeERC20 for IERC20;

    // 每秒产出利息
    uint public interest;
    address public rewardToken;
    address public owner;
    address[] public rewarduser;
    
    struct User{
        uint userReward;
        bool userState;
        uint userRewardStartTime;
    }

    mapping(address => User) public User_Map;

    constructor (uint _interest, address _rewardToken) {
        interest = _interest;
        rewardToken = _rewardToken;
        owner = msg.sender;
    }

    function SetReward(address[] memory _rewarduser) public returns (bool) {
        rewarduser = _rewarduser;
        for (uint i; i < rewarduser.length; i++){
            User_Map[_rewarduser[i]].userState = true;
            User_Map[_rewarduser[i]].userRewardStartTime = block.timestamp;
        }
        return(true);
    }

    function GetRewardUser() public view returns (address[] memory) {
        return rewarduser;
    }

    function SetUserReward() public  returns (uint) {
        uint _userReward = (block.timestamp.sub(User_Map[msg.sender].userRewardStartTime)).mul(interest);
        User_Map[msg.sender].userReward = _userReward;
        return _userReward;
    }

    function getUserReward() public view {

        // uint x = User_Map[msg.sender].userRewardStartTime;
        if (User_Map[msg.sender].userRewardStartTime == 0) {
          uint _getuserReward = (block.timestamp - User_Map[msg.sender].userRewardStartTime).mul(interest);
        }      
        else if(User_Map[msg.sender].userRewardStartTime > 0){
        uint w = (block.timestamp - User_Map[msg.sender].userRewardStartTime).mul(interest);
        }      
    }
}
// 5208333333333
// ["0x70bbEa39652CA42C63F70531f8526B35575615A0"]