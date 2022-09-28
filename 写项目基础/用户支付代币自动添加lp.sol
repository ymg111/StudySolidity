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
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

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
    address public liquidityPool;
    address public cakeaddress = 0xFa60D973F7642B748046464e165A65B7323b0DEE;
    address public usdtaddress = 0x8516Fc284AEEaa0374E66037BD2309349FF728eA;
    address public treasury = 0x70bbEa39652CA42C63F70531f8526B35575615A0;
    uint256 public maxPayTokenNumber = 100000000000000000000;
    uint256 private _slippageNumerator = 995;
    uint256 private _slippageDenominator = 1000;

    struct User {
        bool user_bool;
        uint user_nftid;
        uint user_pay;       
    }

    mapping(address => User) public User_Map;


    function swapRouter(address _SwapRouter)public {
        SwapRouter = _SwapRouter;
    }

    function setliquidityPool(address _liquidityAddress) public {
        liquidityPool = _liquidityAddress;
    }

    function liquidityMinProvide(uint256 amount) public view returns (uint256) {
        return amount * _slippageNumerator / _slippageDenominator;
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
            address(this),
            block.timestamp
        );
        uint256 actualOut = SwapResult[1];
        return actualOut;
    }


    function _addLiquidity(address tokenA_, address tokenB_, uint256 amountA_, uint256 amountB_) internal returns (uint256) {
        IERC20(tokenA_).approve(SwapRouter, amountA_);
        IERC20(tokenB_).approve(SwapRouter, amountB_);
        
        uint256 addBefore = IERC20(liquidityPool).balanceOf(address(this));
        IPancakeRouter01(SwapRouter).addLiquidity(
            tokenA_,  // The contract address of the tokenA to add liquidity.
            tokenB_,  // The contract address of the tokenB to add liquidity.
            amountA_,  // The amount of tokenA you'd like to provide as liquidity.
            amountB_, // The amount of toeknB you'd like to provide as liquidity.
            liquidityMinProvide(amountA_),  // The minimum amount of the tokenA to provide (slippage impact).
            liquidityMinProvide(amountB_),  // The minimum amount of the tokenB to provide (slippage impact).
            address(this),  // Address of LP Token recipient.
            block.timestamp
        );

        uint256 addAfter = IERC20(liquidityPool).balanceOf(address(this));
        uint256 actualAddLP = addAfter + addBefore;
        require(actualAddLP > 0, "PXY:E03");
        return actualAddLP;
    }

// 设置的路由合约：0xD99D1c33F9fC3444f8101754aBC46c52416550D1
// lp地址：0xb98C30fA9f5e9cf6749B7021b4DDc0DBFe73b73e


// tokenIn:0xFa60D973F7642B748046464e165A65B7323b0DEE
// tokenOut:0x8516Fc284AEEaa0374E66037BD2309349FF728eA
// amountIn_：1000000000000000000000

   function buy(uint256 _amount) public {

        IERC20(cakeaddress).transferFrom(msg.sender,address(this),_amount);
        uint256 actualOutA = Swap(cakeaddress, usdtaddress, _amount);
        

        uint256 liquidityAmountA = actualOutA / 2;

        uint256 liquidityAmountB = Swap(usdtaddress, cakeaddress, liquidityAmountA);

        uint256 actualAddLP = _addLiquidity(cakeaddress, usdtaddress, liquidityAmountB, liquidityAmountA);

        IERC20(liquidityPool).transfer(treasury,actualAddLP);


    }
}

