//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract GlobalVariables {
    //view 关键字是一个可读变量，可读取局部变量和全局变量   
    function globalVars() external view returns(address,uint,uint) {
        // msg.sender 指调用合约方法人的地址（可为人地址和合约地址）
        address sender = msg.sender;
        // block.timestamp 指调用方法时的时间戳
        uint timestamp = block.timestamp;
        // block.number 指调用方法时的区块号
        uint blockNum = block.number;
        return (sender,timestamp,blockNum); 
    }

}