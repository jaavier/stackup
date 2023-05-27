# Vote Quest
Vote Quest: For this feature, I had to add 2 new functions:
- Vote for a quest
- Remove vote for a quest

## Function `voteQuest`
- **Description**: This function allows players to vote for a specific quest.
- **Justification**: The `voteQuest` function was added to enable players to express their opinions and vote for quests they consider valuable or worthy of approval. By keeping a record of players' votes, the community's opinion can be taken into account when evaluating the quality and interest of a quest. This can help guide the administrator's decisions and encourage active player participation in quest selection and approval.

## Function `removeVoteQuest`
- **Description**: This function allows players to remove their previously cast vote for a quest.
- **Justification**: The `removeVoteQuest` function was implemented to allow players to modify their vote in case they change their minds or wish to revoke their initial vote. This provides flexibility and allows players to adjust their preferences and choices regarding the quests they are interested in. By recording and updating players' votes, a fair and transparent voting system for quests is maintained.

# Withdraw Rewards
This feature is slightly more complex as it required adding functions for:
- Approving the quest: This function is vital as it allows the administrator to approve the withdrawal of rewards. A new state called APPROVED was added to the enum.
- Rejecting the quest: Previously, only the SUBMITTED state existed, so the REJECTED state was also added to enable quest rejection.
- Withdrawing the rewards: This function allows players to withdraw the rewards from their quest. Rewards can only be withdrawn if the quest's state is APPROVED.

## Function `approveSubmission`
- **Description**: This function allows the administrator to approve a quest submitted by a player.
- **Justification**: The `approveSubmission` function was created to provide the administrator with the ability to review and approve quests submitted by players. By approving a quest, the administrator indicates that it has been successfully fulfilled, and the player can claim the corresponding reward. This ensures that only valid and approved quests are eligible for reward withdrawal.

## Function `rejectSubmission`
- **Description**: This function allows the administrator to reject a quest submitted by a player.
- **Justification**: The `rejectSubmission` function was implemented to enable the administrator to reject quests that do not meet the requirements or are not valid. By rejecting a quest, the administrator informs the player that their quest has been rejected and provides a reason or additional explanation if necessary. This helps maintain the integrity and quality of approved quests and ensures that players receive feedback on rejected quests.

## Function `withdrawReward`
- **Description**: This function allows players to withdraw their rewards once the quest has been approved.
- **Justification**: The `withdrawReward` function is designed to enable players to obtain their rewards after their quest has been approved by the administrator. By verifying that the quest's state is "APPROVED" for the player, it ensures that only players whose quests have been approved can withdraw their rewards. This provides a secure and reliable way for players to obtain their rewards for completing quests.