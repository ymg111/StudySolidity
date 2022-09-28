 // SPDX-License-Identifier: MIT  
pragma solidity ^0.8.7;  
interface IERC20 {
    function transfer(address recipient, uint amout) external returns (bool);
    function transferFrom(address sender, address recipient, uint amout) external returns (bool);
    function balanceOf(address tokenOwner) external view returns (uint balance);

}


contract Airdrop {
    address public AirdropToken;
    address public owner;
    uint public _getSendTokenNumber;

    constructor (address _token) {
        require(_token != address(0),"NOT,S 0xADDRESS");
        AirdropToken = _token;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require (owner == msg.sender,"NOT,S owner");
        _;
    }


    function sendAirdrop(address[] calldata _userAddress, uint[] calldata _sendTokenNumber) external onlyOwner returns(uint) {
        require(_userAddress.length == _sendTokenNumber.length, "NOT,S LENGTH ==");
        uint a = 0;

        for (uint t; t < _sendTokenNumber.length; t++) {
            a += _sendTokenNumber[t];
            
        }

        require(a > _getSendTokenNumber, "token insufficient");

        for (uint i; i < _userAddress.length; i++) {
            IERC20(AirdropToken).transferFrom(msg.sender, _userAddress[i],_sendTokenNumber[i]);   
        }
        assert(a == 3);
        return(a);    
    }

    function getSendTokenNumber() public returns (uint) {
        _getSendTokenNumber = IERC20(AirdropToken).balanceOf(address(this));
        return(_getSendTokenNumber);
    }
}