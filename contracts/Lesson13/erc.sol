// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 totalTokens;
    address owner;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
    string _name;
    string _symbol;

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }

    modifier enoughTokens(address _from, uint256 _amount) {
        require(balanceOf(_from) >= _amount, "not enought tokens");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply,
        address shop
    ) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function totalSupply() external view returns (uint256) {
        return totalTokens;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function mint(uint256 amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);
    }

    function burn(address _from, uint256 amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
        emit Transfer(_from, address(0), amount);
    }

    function transfer(address to, uint256 amount)
        external
        enoughTokens(msg.sender, amount)
    {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256)
    {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) public {
        _approve(msg.sender, spender, amount);
    }

    function _approve(
        address sender,
        address spender,
        uint256 amount
    ) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);
        require(
            allowances[sender][recipient] >= amount,
            "check allowance transferFrom!"
        );
        allowances[sender][recipient] -= amount;

        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract MCSToken is ERC20 {
    constructor(address shop) ERC20("MSCToken", "MSC", 20, shop) {}
}

contract MShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint256 _amount, address indexed _buyer);
    event Sold(uint256 _amount, address indexed _seller);

    constructor() {
        token = new MCSToken(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    function sell(uint256 _amountToSell) external {
        require(
            _amountToSell > 0 && token.balanceOf(msg.sender) >= _amountToSell,
            "incorrect amount"
        );
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance in Sell!");

        token.transferFrom(msg.sender, address(this), _amountToSell);

        payable(msg.sender).transfer(_amountToSell); //1wei = 1token;

        emit Sold(_amountToSell, msg.sender);
    }

    receive() external payable {
        uint256 tokensToBuy = msg.value; //1wei = 1token;
        require(tokensToBuy > 0, "not enought funds!");

        uint256 currentBalance = tokenBalance();
        require(currentBalance >= tokensToBuy, "not enought tokens");
        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }

    function tokenBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function withdraft(address payable _to, uint256 _amount)
        external
        onlyOwner
    {
        require(address(this).balance >= _amount, "not enought funds!");
        require(_to != address(0), "zero addr");
        uint256 _amountForTransction = _amount > 0
            ? _amount
            : address(this).balance;
        _to.transfer(_amountForTransction);
    }
}
