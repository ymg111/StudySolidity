//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract Constructor {
    address public owner;
    uint public x;
    // 构造函数关键词constructor，写入_x参数
    // 构造函数函数只能在部署合约时被调用一次，之后不能在进行调用
    constructor(uint _x) {
        // 初始化合约owner，为调用构造函数的发起人
        owner = msg.sender;
        // 将参数_x赋予状态变量x
        x = _x;
    }

}