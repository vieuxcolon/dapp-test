// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InvestmentDAO {
    struct Proposal {
        string description;
        uint256 amount;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        mapping(address => bool) voters;
    }

    address public owner;
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public shares;

    event ProposalCreated(uint256 proposalId, string description, uint256 amount);
    event Voted(uint256 proposalId, address voter, bool support);
    event ProposalExecuted(uint256 proposalId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyShareholder() {
        require(shares[msg.sender] > 0, "Not a shareholder");
        _;
    }

    function invest() external payable {
        shares[msg.sender] += msg.value;
    }

    function createProposal(string memory description, uint256 amount) external onlyShareholder {
        require(amount <= address(this).balance, "Insufficient funds");
        Proposal storage p = proposals[proposalCount];
        p.description = description;
        p.amount = amount;
        proposalCount++;
        emit ProposalCreated(proposalCount - 1, description, amount);
    }

    function vote(uint256 proposalId, bool support) external onlyShareholder {
        Proposal storage p = proposals[proposalId];
        require(!p.voters[msg.sender], "Already voted");
        p.voters[msg.sender] = true;
        if (support) {
            p.votesFor += shares[msg.sender];
        } else {
            p.votesAgainst += shares[msg.sender];
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external onlyShareholder {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Proposal not approved");
        p.executed = true;
        payable(msg.sender).transfer(p.amount);
        emit ProposalExecuted(proposalId);
    }

    function getProposalVotes(uint256 proposalId) external view returns (uint256 votesFor, uint256 votesAgainst) {
        Proposal storage p = proposals[proposalId];
        return (p.votesFor, p.votesAgainst);
    }
}
