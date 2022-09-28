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

interface MintNFT {
      function proxyMint(address recipient) external returns (uint256);
}



contract SWAP{   
    address public SwapRouter;
    address public cakeaddress = 0xFa60D973F7642B748046464e165A65B7323b0DEE;
    address public usdtaddress = 0x8516Fc284AEEaa0374E66037BD2309349FF728eA;
    address public treasury = 0x70bbEa39652CA42C63F70531f8526B35575615A0;
    uint256 public maxPayTokenNumber = 100000000000000000000;
    address public NFTAddress;   // 0xEcD0594aC50B1EfEf0f0df1e1e693cc090430Dc1
    event swapEvent(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event treasuryNumber(uint256 _treasury);

    struct User {
        bool user_bool;
        uint user_nftid;
        uint user_pay;
        
    }

    mapping(address => User) public User_Map;


    function swapRouter(address _SwapRouter)public {
        SwapRouter = _SwapRouter;
    }

    function setNFTAddress(address _NFTAddress) public {
        NFTAddress = _NFTAddress;
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
        uint256 actualIn = SwapResult[0];
        uint256 actualOut = SwapResult[1];
        require(actualIn > 0 && actualOut > 0, "PXY:E02");
        emit swapEvent(tokenIn, tokenOut, actualIn, actualOut);
        return actualOut;
    }

// 设置的路由合约：0xD99D1c33F9fC3444f8101754aBC46c52416550D1

// tokenIn:0xFa60D973F7642B748046464e165A65B7323b0DEE
// tokenOut:0x8516Fc284AEEaa0374E66037BD2309349FF728eA
// amountIn_：1000000000000000000000
    function buy(uint256 _amount) public {
        require(!User_Map[msg.sender].user_bool, "Purchased NFT");
        require(IERC20(cakeaddress).balanceOf(msg.sender) > _amount,"Balance Not Enough");
        require(maxPayTokenNumber == _amount,"Payment quantity exceeds the limit");
        IERC20(cakeaddress).transferFrom(msg.sender,address(this),_amount);
        User_Map[msg.sender].user_bool = true;
        uint NFTid = MintNFT(NFTAddress).proxyMint(msg.sender);
        User_Map[msg.sender].user_nftid = NFTid;
        uint256 actualOutA = Swap(cakeaddress,usdtaddress , _amount);
        uint256 _treasury = actualOutA * 90 /100;
        IERC20(usdtaddress).transfer(treasury,_treasury);
        User_Map[msg.sender].user_pay = _treasury;
        uint256 user = actualOutA - _treasury;
        IERC20(usdtaddress).transfer(msg.sender,user);
        emit treasuryNumber(_treasury);
    }
}


