//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract Constants {
    // constant关键字可将变量变为常量，常量在写入方法调用执行中会节省gas费,并上链后不可修改。
    // 书写标准，常量定义时需要大写和下划线链接， 如 MY_ADDRESS
    // call方法在send方法调用时，会消耗gas费用。
    address public constant MY_ADDRESS = 0x70bbEa39652CA42C63F70531f8526B35575615A0;
    uint public constant MY_UINT = 123;

}  

contract Var {
    address public MY_ADDRESS = 0x70bbEa39652CA42C63F70531f8526B35575615A0;
}      