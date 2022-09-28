// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";



contract bulkSend is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    using SafeERC20 for IERC20;
    address public airdorp; 

    constructor() {
        _disableInitializers();
    }
    function initialize(address _airdorp) initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();
        airdorp = _airdorp;
    }
    function batchTransfer(address[] calldata userAddr,uint256[] calldata amount) external onlyOwner {
        require(userAddr.length == amount.length,"!=length");
        for (uint256 i = 0; i < userAddr.length; i++) {
            IERC20(airdorp).safeTransfer(userAddr[i],amount[i]);
        }
    }
    function _authorizeUpgrade(address newImplementation)internal onlyOwner override{}
}
