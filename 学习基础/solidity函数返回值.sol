//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract FunctionOutputs {

    // 定义returnMany直接返回两个值
    function returnMany() public pure returns (uint, bool) {
        return (1, true);
    }
    // 定义returnName直接返回两个名称和值
    function returnName() public pure returns (uint x, bool b) {
        return (1, true);
    }
    // 定义assigned直接返回函数体中的局部变量值
    function assigned() public pure returns (uint x, bool b){
        x = 1;
        b = true;
    }
    // 定义destAssigned调用returnMany函数两个值
    function destAssigned() public pure {
        (uint x, bool b) = returnMany();       
    }
    // 定义destAssignedTwo返回returnMany函数两个值
    function destAssignedTwo() public pure returns (uint, bool) {
        return returnMany();
    }


    // 定义destAss调用returnMany函数bool值
    function destAss() public pure {
         (, bool b) = returnMany();
    }
    // 定义destAssTwo返回destAss的值，实际结果报错，因为destAss函数没有返回值。
    // function destAssTwo() public pure returns(bool) {
    //     return destAss();
    // }
}