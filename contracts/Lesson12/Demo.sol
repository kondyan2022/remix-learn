// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./ILogger.sol";

contract Demo12 {
    ILogger logger;

    constructor(address _logger) {
        logger = ILogger(_logger);
    }

    receive() external payable {
        //log
        logger.log(msg.sender, msg.value);
    }
  function payment(address _from, uint _number) public view returns(uint) {
    return logger.getEntry(_from, _number);
  } 
}
