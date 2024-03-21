// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract ComRev {
    address[] public candidates = [
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
        0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199,
        0xdD2FD4581271e230360230F9337D5c0430Bf44C0
    ];
  
   mapping(address=>bytes32) public commits;
   bool votingStopped;
//Ответ надо хешировать на фронте чтобі потом нельзя было опредеить кто за кого 
   function commitVote(bytes32 _hashedVote) external {

   }

}
