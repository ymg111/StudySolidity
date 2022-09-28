//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract LocalVariables {
    uint public i;
    bool public b;
    address public myAddress;
    //定义函数为foo，调用方法后将更新上面变量
    function foo() external {
        uint x = 123;
        bool f = false;
        i += 456;
        b = true;
        myAddress = address(1);
    }
}
