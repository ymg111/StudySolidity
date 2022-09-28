//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;


// 枚举比bool值可拥有更多的状态,枚举与结构体都是一种类型,枚举的默认值都是第一个字段。
contract Enum {
    // 声明一个枚举定义为Status
    enum Status {
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }
    // 将枚举Status定义为变量status
    Status public status;

    struct Order {
        address buyer;
        Status status;
    }

    Order[] public orders;
     

    // 返回变量status当前状态
    function get() public view returns (Status) {
        return status;
    }
    // 设置_status，并将_status赋予status
    function set(Status _status) external {
        // require(_status < Status.length , "NOT _status > 5");
        status = _status;
        orders.push(_status);
    }
    // 调用ship方法直接修改status状态为Shipped
    function ship() external {
        status = Status.Shipped;
    }
    // 恢复枚举为默认值
    function reset() external {
        delete status;
    }

}