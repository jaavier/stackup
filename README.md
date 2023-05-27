# Votar Quest
Votar Quest: Para este feature tuve que agregar 2 nuevas funciones:
- Votar por una quest
- Eliminar voto por una quest

## Función `voteQuest`
- **Descripción**: Esta función permite a los jugadores votar por una quest específica.
- **Justificación**: La función `voteQuest` se agregó para permitir a los jugadores expresar su opinión y votar por las quests que consideran valiosas o dignas de aprobación. Al mantener un registro de los votos de los jugadores, se puede tener en cuenta la opinión de la comunidad al evaluar la calidad y el interés de una quest. Esto puede ayudar a guiar las decisiones del administrador y a fomentar la participación activa de los jugadores en la selección y aprobación de quests.

## Función `removeVoteQuest`
- **Descripción**: Esta función permite a los jugadores eliminar su voto previamente emitido para una quest.
- **Justificación**: La función `removeVoteQuest` se implementó para permitir a los jugadores modificar su voto en caso de que cambien de opinión o deseen revocar su voto inicial. Esto brinda flexibilidad y permite a los jugadores ajustar sus preferencias y elecciones en relación con las quests en las que están interesados. Al registrar y actualizar los votos de los jugadores, se mantiene un sistema justo y transparente para la votación de quests.


# Retirar Ganancias
Este feature es un poco más complicado, ya que se tuvieron que agregar funciones para:
- Aprobar el quest: Esta función es vital, ya que es la que le permite al administrador aprobar el retiro de las ganancias. Se agregó un nuevo estado al enum llamado APPROVED.
- Rechazar el quest: Anteriormente solo existía el estado SUBMITTED, por lo que también se agregó el estado REJECTED para poder rechazar el quest.
- Retirar las ganancias: Esta función es la que le permite al jugador retirar las ganancias de su quest. Solo se puede retirar las ganancias si el estado del quest es APPROVED.
## Función `approveSubmission`
- **Descripción**: Esta función permite al administrador aprobar una quest enviada por un jugador.
- **Justificación**: La función `approveSubmission` se creó para brindar al administrador la capacidad de revisar y aprobar las quests enviadas por los jugadores. Al aprobar una quest, el administrador indica que se ha cumplido con éxito y que el jugador puede reclamar el reward correspondiente. Esto asegura que solo las quests válidas y aprobadas sean elegibles para el retiro del reward.

## Función `rejectSubmission`
- **Descripción**: Esta función permite al administrador rechazar una quest enviada por un jugador.
- **Justificación**: La función `rejectSubmission` se implementó para que el administrador pueda rechazar quests que no cumplen con los requisitos o no son válidas. Al rechazar una quest, el administrador informa al jugador que su quest ha sido rechazada y proporciona una razón o explicación adicional si es necesario. Esto ayuda a mantener la integridad y la calidad de las quests aprobadas y asegura que los jugadores reciban feedback sobre las quests rechazadas.

## Función `withdrawReward`
- **Descripción**: Esta función permite a los jugadores hacer el retiro de su reward una vez que la quest ha sido aprobada.
- **Justificación**: La función `withdrawReward` se diseñó para permitir que los jugadores obtengan su reward después de que su quest ha sido aprobada por el administrador. Al verificar que el estado de la quest sea "APPROVED" para el jugador, se garantiza que solo los jugadores cuyas quests han sido aprobadas puedan retirar su reward. Esto proporciona una forma segura y confiable para que los jugadores obtengan su recompensa por completar las quests.
