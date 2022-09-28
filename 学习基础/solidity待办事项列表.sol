//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }
    // 将结构体Todo创建为一个数据
    Todo[] public todos;

    // 定义方法create，使用calldata关键字，将输入的_text参数存储在Todo结构体的text参数中。
    function create(string calldata _text) external {
        // 将Todo结构体的两个参数值，push推入todos数组中，修改Todo结构体的两个参数值
        todos.push(Todo({text: _text,completed: false}));
    }

    // calldata关键词只能指定数组、结构或映射类型指定数据，不能加bool值
    function createTwo(string calldata _text, bool _completed) external {
        // 将Todo结构体的两个参数值，push推入todos数组中，修改Todo结构体的两个参数值
        todos.push(Todo({text: _text,completed: _completed}));
    }

    // // 定义更新结构体数据方法updateText
    // // 使用_index索引值和_text修改结构体中text数据的值
    // //如结构体中需要更新单个参数，使用索引存储相对于storage存储更节省gas
    function updateText(uint _index, string calldata _text) external {
        // 将结构体装载在索引中，调用输入的索引值，并将参数_text，修改在该索引下。
        todos[_index].text = _text;
    }

    function updateTextTwo(uint _index, string calldata _text, bool _completed) external {

        // 将结构体Todo装到storage存储的todo变量中
        // 如结构体中需要更新多个参数，使用storage存储相对于索引存储更节省gas
        Todo storage todo = todos[_index];
        todo.text = _text;
        todo.completed = _completed;
    }

    // 定义函数get返回结构体的数据
    function get(uint _index) external view returns (string memory, bool) {
        // 可使用memory和storage存储，memory更节约gas
        Todo memory todo = todos[_index];
        // Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    function toggleComplated(uint _index) external {
        // 将索引的值！反转后赋予索引值
        todos[_index].completed = !todos[_index].completed;
    }

    function toggleComplatedtwo(uint _index, bool _completed) external {
        todos[_index].completed = _completed;
    }

}