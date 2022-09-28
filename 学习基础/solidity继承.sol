//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract A {

    // virtual关键词可使继承的合约重写这个方法
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
    function bar() public pure virtual returns (string memory) {
        return "A";
    }

    function three() public pure returns (string memory) {
        return "A";
    }
}

// A合约作为父合约继承给子合约B
contract B is A {
    // override关键词证明可覆盖父合约的方法
    function foo() public pure override returns (string memory) {
        return "B";
    }

    // 在多起继承时必须同时使用virtual和override关键字
    function bar() public pure virtual override returns (string memory) {
        return "B";
    }

}

// B合约作为父合约继承给子合约C
contract C is B {

    function bar() public pure override returns (string memory) {
        return "C";
    }
}