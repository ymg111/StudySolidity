//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract ValueTypes {
    bool public b = true;
    uint public u = 123;   // uint = uint256  0到2**256 - 1
    int public i = -123;  // int = int256 -2**255到2**255 - 1
    //定义有符号整数的最小值
    int public minInt = type(int).min;
    //定义有符号整数的最大值
    int public maxInt = type(int).max;
    address public addr = 0x70bbEa39652CA42C63F70531f8526B35575615A0;
}