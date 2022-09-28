//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract Error {
    // require方法判断_i <= 10，如果成功代码继续运行，否则直接报错
    function testRequire(uint _i) public pure {
        require(_i <= 10, "i Cannot be greater than 10");
        // code
    }
    // revert方法判断_i > 10，如果输入大于10，直接报错和
    // revert方法判断_i < 2,如果输入小于2，直接报错
    // revert不能包含表达式，必须使用if，else表达。
    function testRevert(uint _i) public pure {
        if (_i > 10) {
            revert("i Cannot be greater than 10");
        }
        if (_i < 2) {
            revert("i Cannot be greater than 2");  
        }
    }
    uint public num = 123;
    // asser表示断言，只能进行断言判断，没有报错信息
    function testAssert() public view {
        // 如果num不等于123，则会断言报错
        assert(num == 123);
    }

    // gas费返回实例
    function foo(uint _i) public {
        // 调用状态变量num，每次调用foo函数则num+1，如果调用foo方法失败则num不进行增加。
        num += 1;
        // 如果输入_i < 10，则报错
        require(_i < 10," I CANT < 10 ERROR");
    }

    // 自定义报错信息，优点在于可节省报错信息过长的gas费用。
    error MyError(address caller, uint i);
    function testCustomError(uint _i) public view {
        if (_i > 10) {
            revert MyError(msg.sender, _i);
        }
    } 
}