// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MyContract17a {
    address otherContract;

    constructor(address _otherContract) {
        otherContract = _otherContract;
    }

    function delCallGetData() external payable {
        (bool success, ) = otherContract.delegatecall(    //запуск функции в контексте єтого контракта
            abi.encodeWithSelector(AnotherContract17a.getData.selector)
        );
        require(success, "failed!");
    }
}

contract AnotherContract17a {
    event Received(address sender, uint256 value);
  
    function getData() external payable {
        emit Received(msg.sender, msg.value);
    }
}
