// SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  

contract PiggyBank {

    event Deposit(uint amout);
    event withDraw(uint amout);
    // 将部署人地址赋予owner权限，相当于构造函数赋予，这种更方便。
    address public owner = msg.sender;
    uint public values;

    // 回退函数，收款方法，任何人都可以给合约中发送eth代币。
    receive() external payable {
        // 事件返回调用者存币数量，使用msg.value
        emit Deposit(msg.value);
        // 定义values状态变量，每存一次eth，进行累加。
        values = address(this).balance;
    }

    function withdraw() external {
        // 判断调用取款方法的地址是否与owner一致。
        require(msg.sender == owner, "not owner");
        // 事件获取当前合约eth余额，使用address(this).balance
        emit withDraw(address(this).balance);
        // selfdestruct关键字为销毁合约方法,销毁后将eth退给owner地址
        selfdestruct(payable(msg.sender));
    }
    // 返回values数量
    function get() external view returns(uint) {
        return (values);
    }

}