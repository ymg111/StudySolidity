//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract Event {
    event Log(string message, uint val);
    // 一个合约中只能拥有三个索引事件
    event IndexedLog(address indexed sender, uint val);
    uint public tokenId = 0;

    function example() external {
        emit Log("FOO",1234);
        emit IndexedLog(msg.sender,789);
    }

    event Message(address indexed _from, address indexed _to, string message, uint tokenId);

    // 注意事项：字符串类型的参数需要加calldata关键字
    function sendMessage(address _to, string calldata message) external {    
        emit Message(msg.sender, _to, message, tokenId);
        tokenId += 1;
    }
}