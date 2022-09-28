   // SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;  
 
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amout) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amout) external returns (bool);

    function transferFrom(address sender, address recipient, uint amout) external returns (bool);

    event Trasfer(address indexed from, address indexed to, uint amout);
    event Approveal(address indexed owner, address indexed spender, uint amout);

}

contract StakeContract {
    // uint public stakeTime;
    uint public ratio;
    address public staketoken;
    address public totoken;
    uint public stakeSupple;
    address public owner;
    // 总时间的一个代币奖励数量
    uint public max_a_token_reward;
    // 项目上次更新时间
    uint public max_last_stake_time;
    // 项目上次一个代币奖励数量
    uint public max_last_a_token_reward;
    // 设置时间戳
    uint public set_block_time;

    
    event Trasfer(address indexed from, address indexed to, uint amout);
    event Approveal(address indexed owner, address indexed spender, uint amout);
    event transfer(address indexed to, uint amout);

    struct User {
        uint stakeNumber;
        uint last_Stake_Time;
        uint last_totoken_ratio;
        // 用户每个代币奖励数量  
        uint user_a_token_reward;
    }

    mapping(address => User) public User_Map;

    constructor (address _staketoken, address _totoken) {
        owner = msg.sender;
        require(_staketoken != address(0),"NOT,S 0X ADDRESS");
        require(_totoken != address(0),"NOT,S 0X ADDRESS");
        require(_staketoken == _totoken,"NEED agreement");
        staketoken = _staketoken;
        totoken = _totoken;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "not owner");
        _;
    }

    // function getStakeTime() public view returns (uint) {
    //     return stakeTime;
    // }

    function setRatio(uint _ratio) external onlyOwner {    
        ratio = _ratio;     
    }

    function stake(uint _amount) public returns (bool) {
        IERC20(staketoken).transferFrom(msg.sender, address(this), _amount); 
        emit Trasfer(msg.sender, address(this), _amount);
        // 将总时间的一个代币奖励数量赋予项目上次一个代币奖励数量
        max_last_a_token_reward = max_a_token_reward;
        // 定义一秒产出数量变量
        uint proportion;
        if (stakeSupple != 0) {
            // 一秒一个代币产出数量 = 每秒产出总数量/质押总数量
            proportion = ratio * 10**40 / stakeSupple ;           
        }
        // 当前时间一个代币产出数量 = （当前时间 - 上次质押时间）* 一秒产出数量
        uint current_max_a_token_reward = (set_block_time - max_last_stake_time)* proportion;
        // 总时间的一个代币奖励数量 = 总时间的一个代币奖励数量+当前时间一个代币产出数量
        max_a_token_reward = max_a_token_reward + current_max_a_token_reward;
        // 更新累计奖励 = 未领取累计代币奖励数量 + （总时间的一个代币奖励数量 - 项目上次一个代币奖励数量）*用户质押数量
        User_Map[msg.sender].last_totoken_ratio =  User_Map[msg.sender].last_totoken_ratio + ((max_a_token_reward - max_last_a_token_reward)* User_Map[msg.sender].stakeNumber) / 10**40;
        // 更新用户质押数量
        User_Map[msg.sender].stakeNumber += _amount;
        // 更新总质押数量
        stakeSupple += _amount;
        // 更新项目上次一个代币奖励数量为当前时间
        max_last_stake_time = set_block_time;
        // 更新用户每个代币奖励数量为总时间的一个代币奖励数量
        User_Map[msg.sender].user_a_token_reward = max_a_token_reward;
        return true;    
    }  
      
    function harvest() public {
        // 更新总时间的一个代币奖励数量
        max_a_token_reward = max_a_token_reward + ((set_block_time - max_last_stake_time) * ratio * 10**40 / stakeSupple);

        // 用户可领取数量 = 用户累计未领取数量+（总时间的一个代币奖励数量 - 用户每个代币奖励数量）*用户质押数量
        uint harvest_total_number = User_Map[msg.sender].last_totoken_ratio + ((max_a_token_reward - User_Map[msg.sender].user_a_token_reward)* User_Map[msg.sender].stakeNumber) /10**40;
        IERC20(totoken).transfer(msg.sender, harvest_total_number);
        emit transfer(msg.sender, harvest_total_number);
        // 更新未领取累计代币奖励数量 = 0
        User_Map[msg.sender].last_totoken_ratio = 0;
        // 更新用户每个代币奖励数量为总时间的一个代币奖励数量
        User_Map[msg.sender].user_a_token_reward = max_a_token_reward;
        
    }

    function withdrawharvest() public {
        uint harvest_total_number = User_Map[msg.sender].last_totoken_ratio + (max_a_token_reward - User_Map[msg.sender].user_a_token_reward)* User_Map[msg.sender].stakeNumber;
        IERC20(totoken).transfer(msg.sender, harvest_total_number);
        emit transfer(msg.sender, harvest_total_number);
        User_Map[msg.sender].last_totoken_ratio = 0;
        User_Map[msg.sender].user_a_token_reward = max_a_token_reward;

        IERC20(staketoken).transfer(msg.sender, User_Map[msg.sender].stakeNumber); 
        emit transfer(msg.sender, User_Map[msg.sender].stakeNumber);
        stakeSupple -= User_Map[msg.sender].stakeNumber;
        User_Map[msg.sender].stakeNumber = 0;

    }

    function setblocktime(uint _blocktime) public {
        set_block_time = _blocktime;
    }
}

//  每秒奖励      
// 200000000000000000000


