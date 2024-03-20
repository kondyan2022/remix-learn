// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Demo {
    //public external internal private
    // view pure
    string message = "Hello!";

    fallback() external payable {}

    receive() external payable {}

    function pay() external payable {}

    // transaction
    function setMessage(string memory newMessage) external {
        message = newMessage;
    }

    //call
    function getBallance() public view returns (uint256 balance) {
        balance = address(this).balance;
        // return balance
    }

    function getMessage() external view returns (string memory) {
        return message;
    }
}
