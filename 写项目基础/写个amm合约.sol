 // SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  
interface IERC20 {
    function transfer(address recipient, uint amout) external returns (bool);
    function transferFrom(address sender, address recipient, uint amout) external returns (bool);
}
contract Stopcock {
    address public  BTCtoken;
    address public  ETHtoken;
    uint public ReceivedBTCTokenNumber;
    uint public ReceivedETHTokenNumber;
    uint public MaxTokenLimit;
    address public owner;
    uint public tradeETHproportion;
    uint public tradeBTCproportion;

    struct User{
        uint claimBTCNumber;
        uint claimETHNumber;
    }

    mapping(address => User) public User_Map;


    constructor(address _BTCtoken, address _ETHtoken, uint _ReceivedBTCTokenNumber, uint _ReceivedETHTokenNumber){
        require(_BTCtoken != _ETHtoken);
        owner = msg.sender;
        BTCtoken = _BTCtoken;
        ETHtoken = _ETHtoken;
        ReceivedBTCTokenNumber = _ReceivedBTCTokenNumber;
        ReceivedETHTokenNumber = _ReceivedETHTokenNumber;
    }


    function claimBTC(uint _claim) public returns (bool) {
        require(User_Map[msg.sender].claimBTCNumber  < 10000000000000000000, "claim beyond");
        IERC20(BTCtoken).transfer(msg.sender,_claim);
        User_Map[msg.sender].claimBTCNumber += _claim;
        ReceivedBTCTokenNumber += _claim;
        tradeBTCproportion = ((ReceivedETHTokenNumber * 1000000000000000000) / ReceivedBTCTokenNumber);  
        return(true);
    }

    function claimETH(uint _claim) public returns (bool) {
        require(User_Map[msg.sender].claimETHNumber   < 10000000000000000000, "claim beyond");
        IERC20(ETHtoken).transfer(msg.sender,_claim);
        User_Map[msg.sender].claimETHNumber += _claim;
        ReceivedETHTokenNumber += _claim;
        tradeETHproportion = ((ReceivedBTCTokenNumber * 1000000000000000000) /  ReceivedETHTokenNumber);
        return(true);
    }

    function trade(address _fromToken, address   , uint _fromAmount) public returns (bool) {
        if (_fromToken == BTCtoken) {
            IERC20(BTCtoken).transferFrom(msg.sender, address(this), _fromAmount);
            ReceivedBTCTokenNumber += _fromAmount;
            // 使用eth总数除以btc总数，算出来一个btc可以兑换多少eth的数量 你
            // 使用需要btc数量*兑换比例 = 需要发送的eth代币数量
            tradeBTCproportion = ((ReceivedETHTokenNumber * 1000000000000000000) /  ReceivedBTCTokenNumber);
            uint send_ethTokenNumber = (_fromAmount * tradeBTCproportion) / 1000000000000000000;
            IERC20(ETHtoken).transfer(msg.sender,send_ethTokenNumber);
            ReceivedETHTokenNumber -= send_ethTokenNumber;
        }

        else if(_fromToken == ETHtoken) {
            IERC20(ETHtoken).transferFrom(msg.sender, address(this), _fromAmount);
            ReceivedETHTokenNumber += _fromAmount;
            tradeETHproportion = ((ReceivedBTCTokenNumber * 1000000000000000000) /  ReceivedETHTokenNumber);
            uint send_btcTokenNumber = (_fromAmount * tradeETHproportion) / 1000000000000000000;
            IERC20(BTCtoken).transfer(msg.sender,send_btcTokenNumber);
            ReceivedBTCTokenNumber -= send_btcTokenNumber;
        }
        return true;
    }  
}     