// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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
interface IPancakeRouter01 {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
contract swap{   
    address public SwapRouter;
    function swapRouter(address _SwapRouter)public {
        SwapRouter = _SwapRouter;
    }

    function Swap(address tokenIn, address tokenOut, uint256 amountIn_)public returns(uint) {
       address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amounts = IPancakeRouter01(SwapRouter).getAmountsOut(amountIn_, path);
        IERC20(tokenIn).approve(SwapRouter, amountIn_);

        uint256[] memory SwapResult = IPancakeRouter01(SwapRouter).swapExactTokensForTokens(
            amountIn_,  // the amount of input tokens.
            amounts[1],  // The minimum amount tokens to receive.
            path,  // An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.
            msg.sender,  // Address of recipient.
            block.timestamp  // Unix timestamp deadline by which the transaction must confirm.
        );
        uint256 actualIn = SwapResult[0];
        uint256 actualOut = SwapResult[1];
        require(actualIn > 0 && actualOut > 0, "PXY:E02");
        return actualOut;
    }



}