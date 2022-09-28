 // SPDX-License-Identifier: MIT  
pragma solidity ^0.8.6;

import "./safeMath/safemath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract StakeContract {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

    // 利息
    uint public ratio;
    // 质押代币 
    address public staketoken;
    // 奖励代币
    address public rewardtoken;
    // 质押总数
    uint public staketotal;
    address public owner;

    struct User {
        // 用户质押数量
        uint stakeNumber;
        // 上次质押时间
        uint last_Stake_Time;
        // 上次累计未领取奖励代币数量
        uint last_totoken_ratio;  
        // 所有可领取奖励代币数量
        uint whole_ratio;
        // 开始收益时间
        uint last_totoken_Time;
    }

    event Trasfer(address indexed from, address indexed to, uint amout);
    event Approveal(address indexed owner, address indexed spender, uint amout);
    event transfer(address indexed to, uint amout);

    mapping(address => User) public User_Map;

    constructor (address _staketoken ,address _totoken) {
        owner = msg.sender;
        require(_staketoken != address(0),"NOT,S 0X ADDRESS");
        require(_totoken != address(0),"NOT,S 0X ADDRESS");
        require(_staketoken == _totoken,"NEED agreement");
        staketoken = _staketoken;
        rewardtoken = _totoken;
    }

    // 设置年化利息
    function setratio(uint _ratio) external {
        ratio = _ratio;    
    }

    // 质押方法
    function deposit(uint _amount) public returns (bool) {
        // 判断用户余额是否大于质押数量
        require(IERC20(staketoken).balanceOf(msg.sender) > _amount, "Balance Insufficient");
        // 用户发送代币
        IERC20(staketoken).safeTransferFrom(msg.sender, address(this), _amount);
        // 计算上次累计未领取奖励代币数量
        uint unClime_Reward_Token_Number = (block.timestamp.sub(User_Map[msg.sender].last_Stake_Time))
        .mul((User_Map[msg.sender].stakeNumber.mul(ratio).div(100))
        .div(31536000)); 

        emit Trasfer(msg.sender, address(this), _amount);

        // 将每次的上次未领取奖励代币数量累计起来
        User_Map[msg.sender].last_totoken_ratio += unClime_Reward_Token_Number;
        // 每次质押需要更新用户质押数量
        User_Map[msg.sender].stakeNumber += _amount;
        // 每次质押将上次质押时间更新为当前时间；
        User_Map[msg.sender].last_Stake_Time = block.timestamp;
        // 每次用户质押将质押总数更新
        staketotal += _amount;
        // 将上次质押时间赋给开始计算收益时间
        User_Map[msg.sender].last_totoken_Time = User_Map[msg.sender].last_Stake_Time;
        return (true);
    }

        // 解压并收获方法
        function harvestwithDraw() public returns (bool) {
        // 计算出用户可领取奖励代币总数量
        User_Map[msg.sender].whole_ratio = User_Map[msg.sender].last_totoken_ratio
        .add((block.timestamp.sub(User_Map[msg.sender].last_Stake_Time))
        .mul(((User_Map[msg.sender].stakeNumber.mul(ratio).div(100)).div(31536000))));

        // 调用合约奖励代币余额方法，赋给x，判断x要大于取出代币数量
        uint x =  tokennumber();
        require (x > User_Map[msg.sender].whole_ratio,"rewardtoken Insufficient");
        // 发送计算的所有可领取代币总数量发送给用户
        IERC20(rewardtoken).safeTransfer(msg.sender, User_Map[msg.sender].whole_ratio); 

        emit transfer(msg.sender, User_Map[msg.sender].whole_ratio);
        // 发送成功后更新可领取奖励代币总数量=0
        User_Map[msg.sender].whole_ratio = 0;
        // 发送成功后更新上次累计未领取奖励代币数量=0
        User_Map[msg.sender].last_totoken_ratio = 0;
        // User_Map[msg.sender].last_Stake_Time = block.timestamp;

        // 调用合约奖励代币余额方法，赋给x，判断x要大于取出代币数量
        require (x > User_Map[msg.sender].stakeNumber,"rewardtoken Insufficient");
        // 再将用户的质押代币退回给用户
        IERC20(staketoken).safeTransfer(msg.sender, User_Map[msg.sender].stakeNumber); 
        emit transfer(msg.sender, User_Map[msg.sender].stakeNumber);

        // 退回用户本金后，更新总质押数量
        staketotal -= User_Map[msg.sender].stakeNumber;
        // 更新该用户本金 = 0
        User_Map[msg.sender].stakeNumber = 0;      
        return true;
    }
  
        //收获方法 
        function harvest() public returns (bool) {
         // 计算出用户可领取奖励代币总数量
        User_Map[msg.sender].whole_ratio = User_Map[msg.sender].last_totoken_ratio
        .add((block.timestamp.sub(User_Map[msg.sender].last_Stake_Time))
        .mul(((User_Map[msg.sender].stakeNumber.mul(ratio).div(100)).div(31536000))));

        uint x =  tokennumber();
        require (x > User_Map[msg.sender].whole_ratio,"rewardtoken Insufficient");

        // 发送计算的所有可领取代币总数量发送给用户
        IERC20(rewardtoken).safeTransfer(msg.sender, User_Map[msg.sender].whole_ratio); 
        

        emit transfer(msg.sender, User_Map[msg.sender].whole_ratio);
        // 发送成功后更新可领取奖励代币总数量=0
        User_Map[msg.sender].whole_ratio = 0; 
        // 发送成功后更新上次累计未领取奖励代币数量=0
        User_Map[msg.sender].last_totoken_ratio = 0;
        // 将当前时间赋予上次领取奖励时间，领取后查询当前奖励代币数量就清0
        User_Map[msg.sender].last_totoken_Time = block.timestamp;
        // User_Map[msg.sender].last_Stake_Time = block.timestamp;
        return true;    
    }

    // 查询当前奖励代币数量
    function newTotokenRatio() public view returns (uint) {
        // 计算上次奖励时间到现在发了多长时间奖励
        uint newtime = block.timestamp - User_Map[msg.sender].last_totoken_Time;
        // 计算正在产生的收益数量
        uint newTotokenRatione = newtime
        .mul(((User_Map[msg.sender].stakeNumber.mul(ratio).div(100)).div(31536000)))
        .add(User_Map[msg.sender].last_totoken_ratio);
        return newTotokenRatione;  
    }

    // 查询合约奖励代币余额
    function tokennumber() public view returns (uint) {
        uint _rewardtokennumber =  IERC20(rewardtoken).balanceOf(address(this)) ;
        return _rewardtokennumber;
    }    
}