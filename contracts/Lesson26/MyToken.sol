// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./ERC20.sol";

contract MyTorken26 is ERC20 {
    constructor() ERC20("MyToken", "MTK", 1000) {}
}
