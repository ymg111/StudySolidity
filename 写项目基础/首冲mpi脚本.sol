// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IPancakeRouter01 {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);


}

contract SWAP{   
    address public SwapRouter;
    address public payaddress ;
    address public outaddress ;
    function payAddress(address _payaddress)public {
        payaddress = _payaddress;
    }

    function outAddress(address _outaddress)public {
        outaddress = _outaddress;
    }

    function swapRouter(address _SwapRouter)public {
        SwapRouter = _SwapRouter;
    }

    function Swap(address tokenIn, address tokenOut, uint256 amountIn_)internal returns(uint) {
       address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        uint256[] memory amounts = IPancakeRouter01(SwapRouter).getAmountsOut(amountIn_, path);
        IERC20(tokenIn).approve(SwapRouter, amountIn_);
        uint256[] memory SwapResult = IPancakeRouter01(SwapRouter).swapExactTokensForTokens(
            amountIn_,
            amounts[1],
            path,
            msg.sender,
            block.timestamp
        );
        uint256 actualOut = SwapResult[1];
        return actualOut;
    }
    // 正式网
// 设置的路由合约： 0x10ED43C718714eb63d5aA57B78B54704E256024E

// payAddress:0x55d398326f99059fF775485246999027B3197955
// outAddress:0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82
// amountIn_：1000000000000000000


// 测试网
// 设置的路由合约： 0xD99D1c33F9fC3444f8101754aBC46c52416550D1

// tokenIn:0xFa60D973F7642B748046464e165A65B7323b0DEE
// tokenOut:0xbdd9bF6485D89c2383b0426Eefabfdb750681568


    function buy(uint256 _amount) public {
        IERC20(payaddress).transferFrom(msg.sender,address(this),_amount);
        uint256 actualOutA = Swap(payaddress, outaddress, _amount);
    }
}


