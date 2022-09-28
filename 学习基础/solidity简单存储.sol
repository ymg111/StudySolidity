//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract SimleStorage {
    string public text;

    // external外部可见，表示其他方法不能调用该方法
    // 使用calldata存储比memory更节省gas费
    // 使用calldata存储参数值，并赋值给text
    function setCalldata(string calldata _text) external {
        text = _text;
    }
    // 使用memory存储参数值，并赋值给text
    function setMemory(string memory _text) external {
        text = _text;
    }

    // 定义函数get，使用view 读取外部状态变量text值，并返回出来
    // 只能使用局部存储memory
    // 相当于合约将状态变量text的值拷贝在get方法的memory内存中，并返回
    function get() external view returns (string memory) {
        return text;
    }
}