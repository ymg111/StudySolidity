//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract ArrayReplacaLast {
    uint[] public arr = [1, 2, 3, 4];


    // 将[1, 2, 3, 4]---->[1, 4, 3, 4]---->[1, 4, 3]---->[1, 4]
    function remove(uint _index) public {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
        arr.pop();
    }

    function test() external view{
        // arr = [1, 2, 3, 4];
        // remove(1);
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        // assert(arr[2] == 3);      
    }
}