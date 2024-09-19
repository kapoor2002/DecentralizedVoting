pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint votedFor;
    }

    address public electionAdmin;
    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    uint public totalVotes;

    event ElectionResult(uint candidateId, uint voteCount);

    modifier onlyAdmin() {
        require(msg.sender == electionAdmin, "Only admin can call this.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted.");
        _;
    }

    constructor() {
        electionAdmin = msg.sender;
        totalVotes = 0;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        
        voters[msg.sender] = Voter(true, _candidateId);
        candidates[_candidateId].voteCount++;
        totalVotes++;
        
        emit ElectionResult(_candidateId, candidates[_candidateId].voteCount);
    }

    function getCandidate(uint _candidateId) public view returns (string memory, uint) {
        return (candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }
}
