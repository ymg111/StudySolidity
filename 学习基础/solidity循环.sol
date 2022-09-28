//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract ForAndWhileLoops {
    function loops() external pure {
        // 定义一个变量i，i小于10，并没循环一次+1
        for (uint i = 0; i < 10; i++) {
            // 如果i等于3则跳出继续执行循环一次=1
            if (i == 3) {
                continue;
            }
            // 如果i等于5则跳出循环，不在进行+1
            if (i == 5) {
                break;
            }
        }

        uint j = 0;
        while (j < 10) {
            j++;
        }
    }
    function sum (uint _n) external pure returns (uint) {
        uint s;
        for (uint i = 1; i <= _n; i++) {
            s += i;    
        }
        return s;
    }
}