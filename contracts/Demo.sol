// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract MyShop {
    // 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8
    address public owner;
    mapping (address => uint) public payments;

    constructor() {
        owner = msg.sender;
    }

    function payForItem() public payable {
        payments[msg.sender]=msg.value;
    }

    function withdrawAll() public {
        address payable _to=payable(owner);
        address _thisContract = address(this);
        _to.transfer(_thisContract.balance);
    }

}