//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  


//使用solidity版本
pragma solidity ^0.8.7;

//创建合约（contract）方法，并声明合约名称为“HelloWeb3”
contract HelloWeb3{

    //声明一个string（字符串类型），变量名称为“myString”，并赋值为"hello world"。
    //变量为myString，public（公开可读方法）

    string public myString = "hello world";
}

