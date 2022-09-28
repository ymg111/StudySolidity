//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract Counter {
    uint public count;

    function inc() external {
        count += 1;
    } 
    function dec() external {
        count -= 1;
    } 
}
