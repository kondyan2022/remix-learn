// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MyContract17 {
    address otherContract; 
    constructor(address _otherContract) {
       otherContract= _otherContract;
    }

    event Response(string response); 

    function callRecieve() external payable {
       (bool success, ) =  otherContract.call{value: msg.value}("");
       require(success, "can't send funds!"); //transfer - 2300 gas max
    }

    function callSetName(string calldata _name) external {
        (bool success, bytes memory response) = otherContract.call(
            // abi.encodeWithSignature("setName(string)", _name) // universal variant
            abi.encodeWithSelector(AnotherContract17.setName.selector, _name)
        );
        require(success, "can't set name!");
        emit Response(abi.decode(response, (string)));
    }
}

contract AnotherContract17 {
    string public name;
    mapping (address=> uint) public balances;

    function setName(string calldata _name) external returns(string memory){
        name = _name;
        return name;
    }
    receive() external payable { 
        balances[msg.sender]+=msg.value;
    }
}
