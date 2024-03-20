// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract DemoSeven {
    //requre
    //  revert
    //  assert
    address owner;

    constructor() {
        owner = msg.sender;
    }


    event Paid(address indexed _from, uint256 _amount, uint256 _timestamp);

    function pay() public  payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    receive() external payable {
        pay();
    }

    modifier onlyOwner(address _to) {
        require(msg.sender == owner, "You are not owner");
        require(_to != address(0), "incorrect address!");
        _;

        // require(condition);
    }

    function withdraw(address payable _to) external onlyOwner(_to) {
        // panic
        assert(msg.sender == owner);
        // require(msg.sender == owner, "You are not owner");
        // if (msg.sender != owner) {
        //     revert("You are not owner!");
        // }
        _to.transfer(address(this).balance);
    }
}
