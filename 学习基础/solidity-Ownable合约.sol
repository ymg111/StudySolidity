//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract Ownable {
    // 定义状态变量owner
    address public owner;
    address public addr;
    // 定义构造函数，在部署合约后，将部署人地址赋予owner变量。
    constructor() {
        owner = msg.sender;
    }
    // 定义函数修改器为onlyOwner，判断一下调用合约地址是否为owner地址，否则报错
    modifier onlyOwner() {
        require(msg.sender == owner , "not owner");
        _;
    }
    // 修改owner权限，先调用函数修改器onlyOwner进行判断，在进入函数体判断新owner是否为0x地址，否则报错。成功后，将新_newOwner地址赋予owner。
    function setOwner(address _newOwner) external onlyOwner{
        require(_newOwner != address(0), "inbalid address");
        owner = _newOwner;         
    }
    
    // 定义函数onlyOwnerCanCallThisFunc只能被onlyOwner调用
    function onlyOwnerCanCallThisFunc() external onlyOwner {

    }
    // 定义函数anyOneCanCall只能和任意调用
    function anyOneCanCall() external {

    }


}