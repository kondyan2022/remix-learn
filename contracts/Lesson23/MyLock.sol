// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract TimeLock {
    uint256 constant MINIMUM_DELAY = 10;
    uint256 constant MAXIMUM_DELAY = 1 days;
    uint256 constant GRACE_PERIOD = 1 days;
    address[] public owners;
    mapping(address => bool) public isOwner;
    string public message;
    uint256 public amount;
    uint256 public constant CONFIRMATIONS_REQUIRED = 3;

    struct Transaction {
        bytes32 uid;
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmation;
    }

    mapping(bytes32 => Transaction) public txs;

    mapping(bytes32 => mapping(address => bool)) public confirmations;

    mapping(bytes32 => bool) public queue;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not a owner!");
        _;
    }
    event Queued(bytes32 txId);
    event Discarded(bytes32 txId);
    event Executed(bytes32 txId);

    constructor(address[] memory _owners) {
        require(owners.length >= CONFIRMATIONS_REQUIRED, "not enoght owners!");
        for (uint256 i = 0; i < _owners.length; i += 1) {
            address nextOwner = _owners[i];
            require(
                nextOwner != address(0),
                "cant have zero address as owner!"
            );
            require(!isOwner[nextOwner], "duplicate owner");

            isOwner[nextOwner] = true;
            owners.push(nextOwner);
        }
    }

    function addToQueque(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint256 _value,
        uint256 _timestamp
    ) external onlyOwner returns (bytes32) {
        require(
            _timestamp > block.timestamp + MINIMUM_DELAY &&
                _timestamp < block.timestamp + MAXIMUM_DELAY,
            "invalid timestamp"
        );
        bytes32 txId = keccak256(
            abi.encode(_to, _func, _data, _value, _timestamp)
        );
        require(!queue[txId], "allready queued");
        queue[txId] = true;

        txs[txId] = Transaction({
            uid: txId,
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmation: 0
        });

        emit Queued(txId);
        return txId;
    }

    function confirm(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "not queued!");
        require(!confirmations[_txId][msg.sender], "already confirmed!");
        Transaction storage transaction = txs[_txId];

        transaction.confirmation += 1;
        confirmations[_txId][msg.sender] = true;
    }

    function cancelConfirmation(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "not queued!");
        require(confirmations[_txId][msg.sender], "not confirmed!");
        Transaction storage transaction = txs[_txId];

        transaction.confirmation -= 1;
        confirmations[_txId][msg.sender] = false;
    }

    function demo(string calldata _msg) external payable {
        message = _msg;
        amount = msg.value;
    }

    function getNextTimestamp() external view returns (uint256) {
        return block.timestamp + 15;
    }

    function prepareData(string calldata _msg)
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(_msg);
    }

    function execute(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint256 _value,
        uint256 _timestamp
    ) external payable onlyOwner returns (bytes memory) {
        bytes32 _txId = keccak256(
            abi.encode(_to, _func, _data, _value, _timestamp)
        );
        require(queue[_txId], "not queued!");
        require(block.timestamp > _timestamp, "too early");
        require(block.timestamp + GRACE_PERIOD > _timestamp, "tx expired");
        delete queue[_txId];

        Transaction storage transaction = txs[_txId];

        require(
            transaction.confirmation >= CONFIRMATIONS_REQUIRED,
            "not enought confirmation"
        );

        delete queue[_txId];
        transaction.executed = true;

        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }
        (bool success, bytes memory resp) = _to.call{value: _value}(data);
        require(success);
        emit Executed(_txId);
        return resp;
    }

    function discard(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "not queue");
        delete queue[_txId];
        emit Discarded(_txId);
    }
}
