// SPDX-License-Identifier: MIT  

pragma solidity ^0.8.7;   

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amout) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amout) external returns (bool);

    function transferFrom(address sender, address recipient, uint amout) external returns (bool);

    event Trasfer(address indexed from, address indexed to, uint amout);
    event Approveal(address indexed owner, address indexed spender, uint amout);

}

contract ERC20 is IERC20{
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "ymg";
    string public symbol = "YMG_TOKEN";
    uint public decimals = 18;
    address public owner;

    // event Trasfer(address indexed from, address indexed to, uint amout);
    // event Approveal(address indexed owner, address indexed spender, uint amout);

    constructor(uint _totalSupply, uint _decimals) {  
        owner = msg.sender;
        decimals = _decimals;
        totalSupply = _totalSupply * 10 **decimals;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "not owner");
        _;
    }

    function mint(uint amout) external onlyOwner{
        balanceOf[msg.sender] += amout;
        totalSupply += amout;
        emit Trasfer(address(0), msg.sender, amout);
    }

    function burn(uint amout) external onlyOwner{
        balanceOf[msg.sender] -= amout;
        totalSupply -= amout;
        emit Trasfer(msg.sender, address(0), amout);
    }


    function setOwner(address _newOwner) external onlyOwner{
        require(_newOwner != address(0), "inbalid address");
        owner = _newOwner;         
    }

    function setName(string calldata _name) external onlyOwner {
        name = _name;
    }

    function transfer(address recipient, uint amout) external returns (bool) {
        require(balanceOf[msg.sender] > amout, "NO amout");
        balanceOf[msg.sender] -= amout;
        balanceOf[recipient] += amout;
        emit Trasfer(msg.sender, recipient, amout);
        return true;
    }


    function approve(address spender, uint amout) external returns (bool) {
        allowance[msg.sender][spender] = amout;
        emit Approveal(msg.sender, spender, amout);
        return true;
    }

    

    // function allowance(address owner, address spender) external view returns (uint){
    // }

    function transferFrom(address sender, address recipient, uint amout) external returns (bool) {
        require(balanceOf[msg.sender] > amout, "NO amout");
        allowance[sender][recipient] -= amout;
        balanceOf[sender] -= amout;
        balanceOf[recipient] += amout;
        emit Trasfer(sender, recipient, amout);
        return true;
    }
}