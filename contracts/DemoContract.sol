// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Payments {
    //Lesson4

    struct Payment {
        uint256 amount;
        uint256 timestamp;
        address from;
        string message;
    }

    struct Balance {
        uint256 totalPayments;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function currentBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getPayment(address _addr, uint256 _index)
        public
        view
        returns (Payment memory)
    {
        return balances[_addr].payments[_index];
    }

    function pay(string memory message) public payable {
        uint256 paymentNum = balances[msg.sender].totalPayments;
        balances[msg.sender].totalPayments += 1;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );

        balances[msg.sender].payments[paymentNum] = newPayment;
    }

    // bytes
    // bytes32 public myVar = "test here";
    // // bytes public myDynVar = unicode"привет мир";
    //     bytes public myDynVar = "test here";

    // function demo() public view returns (bytes1) {
    //     return myDynVar[0];
    // }
    // enum Status {
    //     Paid,
    //     Delivered,
    //     Received
    // }
    // Array
    // uint256[] public items;
    // uint256 public len;

    // function demo() public {
    //     items.push(4);
    //     items.push(5);
    //     items.push(6);
    //     len = items.length;
    // }

    // function sampleMemory() public view returns(uint[] memory) {
    //     uint[] memory tempArray = new uint[](10);
    //     tempArray[0] =1;
    //     return tempArray;
    // }
    // uint[3][2] public items;

    // function demo() public {
    //     items = [[3,2,4], [6,7,8]];
    // }

    // Status public currentStatus;

    // function pay() public {
    //     currentStatus = Status.Paid;
    // }

    // function delivered() public {
    //     currentStatus = Status.Delivered;
    // }

    // Lesson3
    // address public myAddr = ;
    // string public myStr = "test"; //storage
    // mapping(address => uint256) public payments; //storage

    // function receiveFunds() public payable {
    //     payments[msg.sender] = msg.value;
    // }

    // function transferTo(address targetAddr, uint256 amount) public {
    //     address payable _to = payable(targetAddr);
    //     _to.transfer(amount);
    // }

    // function getBalance(address targetAddr) public view returns (uint256) {
    //     return targetAddr.balance;
    // }

    // function demo(string memory newValueStr) public {
    //     string memory myTempStr = "temp";
    //     myStr = newValueStr;
    // }

    // lesson2
    // uint8 public myVal =1;

    // function inc() public {
    //     unchecked {
    //         myVal -= 1;
    //     }
    // }
    // // unsigned integers
    // signed integers

    // bool public myBool=true; //State

    // function myFunc(bool _inputbool) public {
    //     bool localBool = false;
    //     localBool && _inputbool
    //     localBool || _inputbool
    //     localBool != _inputbool

    // }
}
