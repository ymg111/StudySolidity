// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract IDO{
    
    receive() external payable {}

    function claim() public {
            
    payable(msg.sender).transfer(address(this).balance);

    }
}