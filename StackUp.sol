// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
    enum playerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        APPROVED, // This new state is used to make sure that the user can only withdraw his reward if the quest was approved
        REJECTED // This new state is used to let the user know that his submission was rejected
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 totalVotes; // This new variable is used to know how many votes the quest has
        mapping(address => bool) hasVoted; // This new mapping is used to know if the user has voted the quest
    }

    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => playerQuestStatus))
        public playerQuestStatuses;

    modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }

    // This new modifier is used to know if the user has already joined the quest and not do it in the functions
    modifier playerJoined(uint256 questId) { 
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.JOINED,
            "You have not joined this quest"
        );
        _;
    }

    // This modifier is used to know if the user is the admin (for approve and reject submission)
    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "You have to be admin to execute this function"
        );
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_
    ) external {
        require(msg.sender == admin, "Only the admin can create quests");
        quests[nextQuestId].questId = nextQuestId;
        quests[nextQuestId].title = title_;
        quests[nextQuestId].reward = reward_;
        quests[nextQuestId].numberOfRewards = numberOfRewards_;
        nextQuestId++;
    }

    function joinQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.NOT_JOINED,
            "Player has already joined/submitted this quest"
        );
        playerQuestStatuses[msg.sender][questId] = playerQuestStatus.JOINED;

        Quest storage thisQuest = quests[questId];
        thisQuest.numberOfPlayers++;
    }

    function submitQuest(uint256 questId)
        external
        questExists(questId)
        playerJoined(questId)
    {
        playerQuestStatuses[msg.sender][questId] = playerQuestStatus.SUBMITTED;
    }

    function voteQuest(uint256 questId)
        external
        questExists(questId)
        playerJoined(questId)
    {
        require(
            !quests[questId].hasVoted[msg.sender],
            "Player has voted before this quest"
        );
        quests[questId].hasVoted[msg.sender] = true;
        quests[questId].totalVotes++;
    }

    function removeVoteQuest(uint256 questId)
        external
        questExists(questId)
        playerJoined(questId)
    {
        require(
            quests[questId].hasVoted[msg.sender],
            "Player has not voted this quest"
        );
        quests[questId].hasVoted[msg.sender] = false;
        quests[questId].totalVotes--;
    }

    // This function let an admin approve a quest
    // This function is important to be able to do the withdraw later
    function approveSubmission(uint256 questId, address sender)
        external
        onlyAdmin
    {
        require(
            playerQuestStatuses[sender][questId] == playerQuestStatus.SUBMITTED
        );
        playerQuestStatuses[sender][questId] = playerQuestStatus.APPROVED;
    }

    // This function let an admin reject a quest
    function rejectSubmission(uint256 questId, address sender)
        external
        onlyAdmin
    {
        require(
            playerQuestStatuses[sender][questId] ==
                playerQuestStatus.SUBMITTED ||
                playerQuestStatuses[sender][questId] ==
                playerQuestStatus.APPROVED
        );
        playerQuestStatuses[sender][questId] = playerQuestStatus.REJECTED;
    }

    // This function let a user withdraw his reward if the quest was approved
    function withdrawReward(uint256 questId)
        external
        questExists(questId)
        playerJoined(questId)
    {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.APPROVED,
            "Player cannot claim reward for this quest"
        );
        address payable playerAddress = payable(msg.sender);
        playerAddress.transfer(quests[questId].reward);
    }
}
