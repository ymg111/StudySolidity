// SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  

contract Recaiver {
    event Log(bytes data);

    function transfer(address _to, uint _amount) external {
        emit Log(msg.data);
        // data值为两个部分组成，一是将函数名称和参数类型将数据打包为哈希值，然后取hash的前四位十六进制，二是参数值。
    }
}

// 输入"transfer(address,uint256)"，返回函数名称和参数类型将数据打包为哈希值，然后取hash的前四位十六进制
contract Funtion {
    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}