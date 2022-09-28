//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
// 数组分为动态数组和固定长度数组



contract Array {

    //定义动态数组nums和固定数组numFixed，动态数组只存在于状态变量
    uint[] public nums = [1, 2, 3];
    uint[3] public numFixed = [4, 5, 6];
    uint[] public num = [1, 2, 3];

    function examples() external {
        //push关键字可向数组的尾部推入数据，可增加数组长度
        nums.push(4);   //[1,2,3,4]
        uint x = nums[1];
        // 将nums数组中下标为2的数据修改为777
        nums[2] = 777;   //[1,2,777,4]
        // 将nums数组中下标为1的数据清除，修改为默认值0，不能删除数组的长度。
        delete nums[1];  //[1,0,777,4]
        // pop关键字可将nums数组中最后一个下标删除掉，可删除数组长度
        nums.pop();  //[1,0,777]
        //nums.length可查询nums数组长度
        uint len = nums.length;

        //使用memory定义数组位置，定义新数组的长度为5
        //因为数组在内存中，所以不能使用push和pop修改数组长度，只能通过索引修改值。
        // 在内存中局部只能使用固定长度数组，不能使用动态数组
        uint[] memory a = new uint[](5);
        a[1] = 123;
    }

    function returnArray() external view returns (uint[] memory) {
        return nums;
    }

    function returnTwo() external {
        // numFixed.push(4);
        numFixed[2] = 111;
    }


    function returnnumFixed() external view returns (uint[3] memory) {
        return numFixed;
    }

    function returnnumThree() external view returns (uint[] memory) {
        return num;
    }

}