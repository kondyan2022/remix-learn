// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Ownable {
    address public owner;

    constructor(address ownerOverride) {
        owner = ownerOverride == address(0) ? msg.sender : ownerOverride;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not a owner");
        _;
    }
    function withdraw(address payable _to) public virtual   onlyOwner {
        payable(owner).transfer(address(this).balance); 
    }


}

abstract contract Balances is Ownable {
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function withdraw(address payable _to) public virtual override onlyOwner {
        _to.transfer(address(this).balance);
    }
}

contract MyContract is Ownable, Balances {
    constructor(address _owner) Ownable(_owner) {

    } 
        function withdraw(address payable _to) public override(Balances, Ownable)  onlyOwner {
        // _to.transfer(address(this).balance);
        require(_to!=address(0), "zero addr");
        super.withdraw(_to);

    }
}
