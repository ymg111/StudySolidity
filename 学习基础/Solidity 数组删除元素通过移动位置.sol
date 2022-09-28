//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract ArrayShift {
    uint[] public arr;
    uint[] public arrTwo = [1, 2, 3, 4, 5, 6];

    function example() public {
        arr = [1, 2, 3];
        delete arr[1];    //[1,0,3]
    }


    // 将[1, 0, 3]---->[1, 3, 3]---->[1, 3]
    function removeArr(uint _index) public {
        require(_index < arr.length, "index out of bound");
        // 使用for表示，输入的_index（表示数组下标）等于i，就从i开始进行，i必须小于数组长度-1（数组下标最后一个为2，长度就等于3），每次循环+1.
        for (uint i = _index; i < arr.length - 1; i++) {
            // 循环体表示将arr数组中下标为i+1的值赋予给i
            arr[i] = arr[i + 1];
        }
        arr.pop();


    }
    // 使用断言测试remove函数执行后返回的结果是否正确
    function test() external view{
        assert(arr[0] == 1);
        assert(arr[1] == 3);
        assert(arr.length == 2);
    }
}
       
