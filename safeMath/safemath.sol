 // SPDX-License-Identifier: MIT  
pragma solidity ^0.8.6;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract math {
    using SafeMath for uint;

    function matha(uint _a, uint _b) public view returns (uint)  {
        uint c = _a.add(_b);
        return c;
    }
}