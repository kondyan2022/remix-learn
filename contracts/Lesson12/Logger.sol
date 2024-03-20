// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./ILogger.sol";

contract Logger12 is ILogger {
    mapping(address => uint256[]) payments;

    function log(address _from, uint256 _amount) public {
        require(_from != address(0), "zero address");
        payments[_from].push(_amount);
    }

    function getEntry(address _from, uint256 _index)
        public
        view
        returns (uint256)
    {
        return payments[_from][_index];
    }
}
