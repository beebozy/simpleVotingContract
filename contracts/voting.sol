// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract VotingSystem {
    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
    }

    address public owner;
    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed voter, uint256 proposalId);
    event VotingEnded(uint256 winningProposalId, string winningProposalDescription);

    bool public isVotingActive;
    uint256 public winningProposalId;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to create a proposal
    function createProposal(string memory _description) external onlyOwner {
        proposals.push(Proposal(proposals.length, _description, 0));
        emit ProposalCreated(proposals.length - 1, _description);
    }

    // Start the voting process
    function startVoting() external onlyOwner {
        require(!isVotingActive, "Voting is already active");
        isVotingActive = true;
    }

    // End the voting process and announce the winner
    function endVoting() external onlyOwner {
        require(isVotingActive, "Voting is not active");
        isVotingActive = false;

        // Determine the winning proposal
        uint256 maxVoteCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
        emit VotingEnded(winningProposalId, proposals[winningProposalId].description);
    }

    // Vote for a proposal
    function vote(uint256 _proposalId) external {
        require(isVotingActive, "Voting is not active");
        require(!hasVoted[msg.sender], "You have already voted");
        require(_proposalId < proposals.length, "Invalid proposal ID");

        proposals[_proposalId].voteCount += 1;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, _proposalId);
    }

    // Get details of a proposal
    function getProposal(uint256 _proposalId)
        external
        view
        returns (uint256, string memory, uint256)
    {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.id, proposal.description, proposal.voteCount);
    }
}
