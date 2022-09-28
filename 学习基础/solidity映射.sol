//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

// 映射是常用的数据类型，可以更快的查询数据中是否存在，并不消耗gas
contract Mapping {
    // 记账类型的映射，记录该用户的余额数量，并定义为balances
    mapping(address => uint) public balances;
    // 嵌套式映射，查找某两个地址是否为好友关系，是返回ture，否返回false，并定义为isFriend
    mapping(address => mapping(address => bool)) public isFriend;

    uint bal;

    function examples() external {
        // 设置调用者地址余额等于123
        balances[msg.sender] = 123;
        uint bal = balances[msg.sender];
        uint bal2 = balances[address(1)];  //返回0
        // 调用examples让调用者余额增加456
        balances[msg.sender] += 456;
        // 删除调用者所有余额回到0
        delete balances[msg.sender];

        // 当前调用者和合约地址为好友关系
        isFriend[msg.sender][address(this)] = true;

    }


}