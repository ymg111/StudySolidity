//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract IfElse {
    function example(uint x) external pure returns (uint) {
        if (x < 10) {
            return 1;
        } else if (x < 20) {
            return 2;
        }else {
            return 3;
        }
    }

    // 使用三元运算符执行if，else
    function ternary(uint x) external pure returns (uint) {
        // 如果x小于10则返回1，否则返回2
        return x < 10 ? 1 : 2;
    }
}