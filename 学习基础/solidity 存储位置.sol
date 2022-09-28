//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;


// 存储位置有三种 storage, memory and calldata
// 存储在storage中是状态变量
// 存储在memory中是局部变量
// calldata只能运用在输入的参数中

contract DataLocations {
    struct MyStruct {
        uint foo;
        string text;
    }
    // 定义一个mapping为MyStructs，将结构体MyStruct的数据值，赋予address主键
    // mapping可被定义为一个状态变量
    mapping(address => MyStruct) public MyStructs;

    function examples(uint[] memory y, string memory s) external returns (uint[] memory) {
        // 调用examples方法后，将结构体中的两个参数值，赋予调用者的adderss，并进行修改MyStruct默认初始值
        MyStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        // 使用storage关键字存储状态变量,并存储在结构体中
        // 将MyStructs中调用者的值赋予myStruct，并在之后可对这个值进行读写
        MyStruct storage myStruct = MyStructs[msg.sender];
        // 修改结构体中text的值为foo
        myStruct.text = "foo";

        // 使用memory只能存储于局部变量，不能修改状态变量
        MyStruct memory readOnly = MyStructs[msg.sender];
        readOnly.foo = 456;

        // 定义一个局部变量新数组，在局部变量中数组只能时定长数组
        // uint[] memory memArr = new uint[](3);
        // memArr[0] = 234;
        // return memArr;

    }

        function examplesTwo(uint[] calldata y, string calldata s) external returns (uint[] memory) {
        // 调用examples方法后，将结构体中的两个参数值，赋予调用者的adderss，并进行修改MyStruct默认初始值
        MyStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        // 使用storage关键字存储状态变量,并存储在结构体中
        // 将MyStructs中调用者的值赋予myStruct，并在之后可对这个值进行读写
        MyStruct storage myStruct = MyStructs[msg.sender];
        // 修改结构体中text的值为foo
        myStruct.text = "foo";

        // 使用memory只能存储于局部变量，不能修改状态变量
        MyStruct memory readOnly = MyStructs[msg.sender];
        readOnly.foo = 456;

        _internal(y);

        // 定义一个局部变量新数组，在局部变量中数组只能时定长数组
        // uint[] memory memArr = new uint[](3);
        // memArr[0] = 234;
        // return memArr;

        

    }

    function _internal(uint[] calldata y) private {
        uint x = y [0];
    }


}
