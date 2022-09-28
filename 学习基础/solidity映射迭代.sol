//在写合约时，写上软件许可后，编译就不会报警告
// SPDX-License-Identifier: MIT  
//使用solidity版本
pragma solidity ^0.8.7;
contract IterableMapping {
    mapping(address => uint) public balances;
    mapping(address => bool) public inserted;
    // 记录合约中所有存在的地址
    address[] public keys;

    function set(address _key, uint _val) external {
        // 将主键address[]_key和值uint_val赋予balances
        balances [_key] = _val;
        // 如果插入映射中没有主键_key对应的值
        if (!inserted[_key]) {
            // 将没有主键_key对应的值定义为true
            inserted[_key] = true;
            // 再将该主键推入地址数组
            keys.push(_key);
        }
    }
    // 返回地址数组的长度
    function getSize() external view returns (uint) {
        return keys.length;
    }
    // 返回第0个主键的值
    function first() external view returns (uint) {
        return balances[keys[0]];
    }
   // 返回最后一个主键的值
    function last() external view returns (uint) {
        return balances[keys[keys.length - 1]];
    }

    function get(uint _i) external view returns (uint) {
        return balances[keys[_i]];
    }

}
