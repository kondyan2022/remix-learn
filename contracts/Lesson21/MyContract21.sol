// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MyContract21 {
    function work(string memory _str) external pure returns(bytes32 data) {
        assembly { 
           let ptr := mload(64)
           data:=mload(sub(ptr,32))
        }
    }
}