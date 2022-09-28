//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract ViewAndPureFunctions {
    // 定义一个num状态变量
    uint public num;

    // view可读取所有链上信息，状态变量和全局变量。
    function viewFunc() external view returns (uint) {
        uint numn = num + 5;
        return numn;
    }

    // pure只能读取局部变量，不能读取状态变量和全局变量。
    function pureFunc() external pure returns (uint) {
        return 1;
    }

    function addToNum(uint x) external view returns (uint) {
       uint numb = num + x;
       return numb;
    }

    function add(uint x,uint y) external pure returns (uint) {
        return x + y;
    }
}