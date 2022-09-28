//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract DefaultValues {
    // 定义状态变量b，bool值的默认值为false
    bool public b;
    // uint默认值为0
    uint public u;
    // int默认值为0
    int public i;
    // address默认值为0x0000000000000000000000000000000000000000
    address public a;
    // bytes32默认值为0x0000000000000000000000000000000000000000000000000000000000000000  
    bytes32 public b32;
     // bytes默认值为0x
    bytes public b1;
}