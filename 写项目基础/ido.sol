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



contract IDO{
    address public Owner;
    address public Paytoken = 0xd9145CCE52D386f254917e481eB44e9943F39138;   //购买token
    address public AirdorpToken = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;   //空投token
    uint256 public IdolStarttime;   //ido开始时间
    uint256 public IdoEndTime;        //ido结束时间
    uint256 public DropStartTime;    // 缓释开始时间
    uint256 public DropContinuedTime;       // 缓释持续时间
    uint256 public PaytokenNumber = 100000000000000000000;      //合约收取支付token数量
    uint256 public ReleaseTime;  //每秒缓释数量
    uint256 public NotReleaseAmount;  //用户未缓释空投代币数量
    uint256 public SendAirdorpTokenNumber = 100000000000000000000;  // 发送给用户的空投代币数量
    uint256 public AirdorpTotalNumber = 150000000000000000000; // ido空投总数量
    uint256 public UserAddressNumber; //用户地址数量
    uint256 public TotalPaytokenNumber; //合约总共收到的购买代币数量
    uint256 public TotalAirdorpNumber;  // 合约总共需要发送的空投代币数量
    uint256 public UserAirdorpTotalNumber;  //用户能收到的空投代币数量
    uint256 public UserAirdorpTotalReleaseeNumber; // 用户未缓释空投代币数量


    struct User {
        
        bool User_bool;  //用户购买状态
        uint256 User_TotalAvailableNumber; //用户总领取数量
        uint256 User_NotReleaseeNumber; //用户未缓释数量
        uint256 User_ReleaseeNumber; //用户已缓释数量
        uint256 User_AvailableNumber; // 用户可领取数量
        uint256 User_ReceivedNumber;   // 用户已领取数量 （包含直接发送25%）
        bool User_climabool; //用户领取状态

    }

    mapping(address => User) public UserMap;
  


    modifier onlyOwner() {
        require(msg.sender == Owner , "not owner");
        _;
    }
    
    constructor(
       uint256 _IdolStarttime,
       uint256 _IdoEndTime
    //    uint256 _AirdorpTotalNumber,
    //    uint _PaytokenNumber,
    //    uint _SendAirdorpTokenNumber
       ){
        Owner = msg.sender;
        IdolStarttime = _IdolStarttime;
        IdoEndTime = _IdoEndTime;
        // AirdorpTotalNumber = _AirdorpTotalNumber;
        // PaytokenNumber = _PaytokenNumber;
        // SendAirdorpTokenNumber = _SendAirdorpTokenNumber;
    }

    //设置每秒缓释时间
    function SetReleaseTime(uint _ReleaseTime) public {
        ReleaseTime = _ReleaseTime;
    }

    //设置空投总数量
    function SetAirdorpTotalNumber(uint _AirdorpTotalNumber) public {
        AirdorpTotalNumber = _AirdorpTotalNumber;
    }

    // 购买
    function Stake(uint _amount) public returns (bool){
        require(PaytokenNumber == _amount,"Quantity error");
        require(UserMap[msg.sender].User_bool != true,"Purchased");
        IERC20(Paytoken).transferFrom(msg.sender, address(this), _amount);
        // UserMap[msg.sender].User_TotalAvailableNumber = SendAirdorpTokenNumber;
        UserMap[msg.sender].User_bool = true;
        UserAddressNumber += 1;
        TotalPaytokenNumber += PaytokenNumber;
        TotalAirdorpNumber += SendAirdorpTokenNumber;

        if (TotalAirdorpNumber > AirdorpTotalNumber) {
            uint256 totalAirdorpNumber = AirdorpTotalNumber * 1000 / TotalAirdorpNumber ;
            UserAirdorpTotalNumber = totalAirdorpNumber * SendAirdorpTokenNumber / 1000;
            UserMap[msg.sender].User_TotalAvailableNumber = UserAirdorpTotalNumber;
            UserAirdorpTotalReleaseeNumber = UserAirdorpTotalNumber * 25 / 100;
            ReleaseTime = UserAirdorpTotalReleaseeNumber / DropContinuedTime;
        }

        if (TotalAirdorpNumber < AirdorpTotalNumber) {
            UserAirdorpTotalNumber = SendAirdorpTokenNumber;
            UserMap[msg.sender].User_TotalAvailableNumber = UserAirdorpTotalNumber;
            UserAirdorpTotalReleaseeNumber = UserAirdorpTotalNumber * 25 / 100;
            ReleaseTime = UserAirdorpTotalReleaseeNumber / DropContinuedTime;
        }

        return true;

    }

        //设置缓释开始时间和缓释持续时间
    function SetReleaseeTime(uint _DropStartTime, uint _DropContinuedTime) public returns(uint){
        DropStartTime = _DropStartTime;
        DropContinuedTime = _DropContinuedTime;
        return DropContinuedTime;
    }

    // 用户领取
    function claim() public returns (bool){

        if (UserMap[msg.sender].User_climabool = false){
            uint received = UserAirdorpTotalNumber * 25 / 100;
            IERC20(AirdorpToken).transfer(msg.sender,received); 
            UserMap[msg.sender].User_ReceivedNumber = received;
            UserMap[msg.sender].User_climabool = true;
            UserMap[msg.sender].User_ReleaseeNumber = (block.timestamp - DropStartTime) * ReleaseTime;
            UserMap[msg.sender].User_NotReleaseeNumber = UserAirdorpTotalReleaseeNumber -UserMap[msg.sender].User_ReleaseeNumber;
            uint claimNumber = UserMap[msg.sender].User_ReleaseeNumber;
            UserMap[msg.sender].User_ReleaseeNumber = 0;
            IERC20(AirdorpToken).transfer(msg.sender,claimNumber); 
        } else {
            UserMap[msg.sender].User_ReleaseeNumber = (block.timestamp - DropStartTime) * ReleaseTime;
            UserMap[msg.sender].User_NotReleaseeNumber = UserAirdorpTotalReleaseeNumber -UserMap[msg.sender].User_ReleaseeNumber;
            uint claimNumber = UserMap[msg.sender].User_ReleaseeNumber;
            UserMap[msg.sender].User_ReleaseeNumber = 0;
            IERC20(AirdorpToken).transfer(msg.sender,claimNumber); 
            
        }



        return true;
    }

    // 项目暂停

    function sendSuspend() public {
        uint256 ReleaseeNumber = (block.timestamp - DropStartTime) * ReleaseTime;
        UserAirdorpTotalReleaseeNumber = UserAirdorpTotalReleaseeNumber - ReleaseeNumber;

    }

       // 项目开启

    function sendopen() public {
        DropStartTime = block.timestamp;
        ReleaseTime = UserAirdorpTotalReleaseeNumber * 1000 / DropContinuedTime;

        
    }


}