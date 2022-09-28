//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract FunctionModifier {
    bool public paused;
    uint public count;
    function setPause(bool _paused) external {
        paused = _paused;
    }

    // 定义函数修改器使用modifier关键词，定义为whenNotPaused
    // 使用函数修改器更方便维护代码，直接修改其他相同处的代码，不需要多次修改。
    modifier whenNotPaused() {
        // !表示false
        require(!paused,"paused");
        // 下划线代表之后的代码在require(!paused,"paused");之后运行
        _;
    }
    // 表示如果paused为false则count+1，为true直接报错
    function inc() external whenNotPaused {
        // require(!paused,"paused");
        count += 1;
    }

    function dec() external whenNotPaused {
        // require(!paused,"paused");
        count -= 1;
    }

    // 使用函数修改器调用有参数的值，
    modifier cap(uint _x) {
        require(_x < 100, "x >= 100");
        _;
    }
    // 调用incBy函数时，输入参数，先调用whenNotPaused函数修改器判断是否为false，在调用cap函数修改器，并传入_x进行判断，再执行count逻辑
    function incBy(uint _x) external whenNotPaused cap(_x) {
        // require(_x < 100, "x >= 100");
        count += _x;
    }

    // 使用函数修改器将运行代码放在中间使用
    modifier sandwich() {
        count += 10;
        _;
        count *= 2;
    }
    function foo() external whenNotPaused sandwich {
        count += 1;
    }


}