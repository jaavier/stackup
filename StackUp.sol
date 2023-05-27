// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
    enum playerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        APPROVED, // Este nuevo estado se utiliza para saber si se puede hacer el withdraw
        REJECTED // Este nuevo estado se utiliza para hacer saber al usuario que su quest fue rechazada
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 totalVotes; // Este nuevo campo se utiliza para saber cuántos votos tiene una quest
        mapping(address => bool) hasVoted; // Este nuevo mapping se utiliza para saber si un usuario ya votó o no
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

    // Este nuevo modifier se utiliza para saber si el usuario ya se unió a la quest y no hacerlo en las funciones
    modifier playerJoined(uint256 questId) { 
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.JOINED,
            "You have not joined this quest"
        );
        _;
    }

    // Este nuevo modifier se utiliza para saber si el usuario es el admin (para approve y reject submission)
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

    // Esta función se utiliza para que un admin pueda aprobar o rechazar una quest
    // Es importante esta función para poder hacer el withdraw posteriormente
    function approveSubmission(uint256 questId, address sender)
        external
        onlyAdmin
    {
        require(
            playerQuestStatuses[sender][questId] == playerQuestStatus.SUBMITTED
        );
        playerQuestStatuses[sender][questId] = playerQuestStatus.APPROVED;
    }

    // Esta función se utiliza para que un admin pueda rechazar una quest
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

    // Esta función se utiliza para que un usuario pueda hacer el withdraw de su reward si la quest fue aprobada
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
