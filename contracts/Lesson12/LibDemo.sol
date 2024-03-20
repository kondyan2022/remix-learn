// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Ext.sol";

contract LibDemo {
    using StrExt for string;
    using ArrayExt for uint256[];

    function runnerArr(uint256[] memory numbers, uint256 number)
        public
        pure
        returns (bool)
    {
        return numbers.inArray(number);
    }

    function runnerStr(string memory str1, string memory str2)
        public
        pure
        returns (bool)
    {
        return str1.eq(str2);
        //    StrExt(str1, str2);
    }
}
