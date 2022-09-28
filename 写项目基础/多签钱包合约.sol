// SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;  

contract MultiSigWallet {

    event Deposit(address indexed sender, uint amout);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);


    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;

    mapping(address => bool) public isOwner;

    uint public required;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;


    modifier onlyOwner() {
        // 判断调用者是否为true，否则报错
        require(isOwner[msg.sender],"not owner");
        _;
    }

    modifier txExists(uint _txId) {
        // 判断索引id要小于数组长度
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier norApproved(uint _txId) {
        // 判断索引id没有进行批准
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        // 判断交易结构体中索引的地址是否为false
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }



    constructor(address[] memory _owners, uint _required) {
        // 判断多签地址大于0
        require(_owners.length > 0, "owners required");
        // 判断多签数量大于0和多签数量小等于多签地址数量。
        require(_required > 0 && _required <= _owners.length,
        "error lengthest");
        // 判断多签地址不是0x地址，并且没有重复的。
        for (uint i; i < _owners.length; i++) {
        address owner = _owners[i];
        require(owner != address(0),"!=0");
        require(!isOwner[owner],"owner is not unique");
        // 将数组owner中的值赋予true，并将局部变量的值push后，修改状态变量owners的值
        isOwner[owner] = true;
        owners.push(owner);
        }
        required = _required;
    }
    

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));    
        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId) external onlyOwner
    txExists(_txId)
    notExecuted(_txId)
    notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for (uint i; i < owners.length; i++) {
            if (approved[_txId][owners[i]]) {
                count += 1;
            }
        }
        // return count;
    }

    function executed (uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");
        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }

}