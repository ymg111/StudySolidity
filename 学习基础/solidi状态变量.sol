//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract StateVariables {
    // 定义一个状态变量myUint为123，部署后永远保存在链上不可进行修改。
    uint public myUint = 123;
    // 定义一个函数为foo
    function foo() external {
        // 定义非状态变量notStateVariables为456.部署后，只有调用foo方法才可进行赋值。
        uint notStateVariables = 456; 
    }        
}