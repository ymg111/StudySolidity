// SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  

contract CallTestContract  {

    // 定义setX方法，参数为需要调用其他合约的合约地址，和需要传递的参数。第一种传递方式
    // function setXone(address _test, uint _x) external {
    //     // 引用TestContract合约调用TestContract合约的setX方法，传递_x参数。
    //     TestContract(_test).setX(_x);
    // }

    // 第二种传递方式
    function setXtwo(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    // 定义getXone方法，参数为需要调用其他合约的合约地址 ，第一种传递方式
    // function getXone(address _test) external view returns (uint) {
    //     // 声明x变量，引用TestContract合约调用TestContract合约的getX方法 赋予x，并返回x的值。
    //     uint x = TestContract(_test).getX();
    //     return x;
    // }

    // 第二种传递方式
    function getXtwo(address _test) external view returns (uint x) {
        // 声明x变量，引用TestContract合约调用TestContract合约的getX方法 赋予x，并返回x的值。
        x = TestContract(_test).getX();
    }

    function setXandReceiveEtherOne(TestContract _test, uint _x) external payable {
        // 这个方法需要将主币eth发送给合约，需要在合约方法中使用全局变量msg.value
        _test.setXandReceiveEther{value: msg.value}(_x);
    }

    function setXandValueone(address _test) external view returns (uint ,uint) {
        // 声明x变量和value变量，引用TestContract合约调用TestContract合约的setXandValue方法 赋予x变量和value变量，并返回x和value的值。
        (uint x, uint value) = TestContract(_test).setXandValue();
        return (x, value);
    }
}


   
contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }
    // payable关键词表示设置eth代币，并发送给合约
    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function setXandValue() external view returns (uint,uint) {
        return (x, value);
    }
}