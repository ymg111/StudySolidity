// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


interface Deposit {
      function deposit(uint256 _amount) external;
}
 
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SWAP{   
    address public SwapRouter;
    address public cakeaddress = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;

    function swapRouter(address _SwapRouter)public {
        SwapRouter = _SwapRouter;
    }

    function _deposit(uint amount_) public {
        IERC20(cakeaddress).transferFrom(msg.sender,address(this),amount_);
        IERC20(cakeaddress).approve(SwapRouter,amount_);
        Deposit(SwapRouter).deposit(amount_);
    }


}