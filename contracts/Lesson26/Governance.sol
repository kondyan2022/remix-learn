// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./IERC20.sol";

contract Governance {
    struct ProposalVote {
        uint256 againstVotes;
        uint256 forVotes;
        uint256 abstainVotes;
        mapping(address => bool) hasVoted;
    }

    struct Proposal {
        uint256 votingStarts;
        uint256 votingEnds;
        bool executed;
    }

    mapping(bytes32 => Proposal) public proposals;

    IERC20 public token;

    constructor(IERC20 _token) {
        token = _token;
    }

    function propose(
        address _to,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        string calldata _description
    ) external {
        require(token.balanceOf(msg.sender) > 1, "not enought tokens");
        bytes32 proposalId = generateProposalId(
            _to,
            _value,
            _func,
            _data,
            keccak256(bytes(_description))
        );
    }

    function generateProposalId(
        address _to,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        bytes32 _descriptionHash
    ) internal pure returns (bytes32) {
        return
            keccak256(abi.encode(_to, _value, _func, _data, _descriptionHash));
    }
}
