 // SPDX-License-Identifier: MIT  
pragma solidity ^0.8.6;

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