//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract FunctionIntro {

    // 定义函数方法function
    // add加法
    // external关键字代表为一个外部函数，并只能被读取
    // pure关键字表示一个纯函数，不能被读，也不能被写状态变量，只能拥有局部变量
    // returns 返回add结果
    function add(uint x,uint y) external pure returns(uint) {
        return x + y;
    }
    // sub减法
    function sub(uint x,uint y) external pure returns(uint) {
        return x - y;
    }
}