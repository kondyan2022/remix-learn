// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IERC20 {
    //not standart, but recomended
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);

    //standart
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external  view returns (uint256);

    function transfer(address to, uint256 amount) external;

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external;

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approve(address indexed owner, address indexed to, uint256 amount);
}
