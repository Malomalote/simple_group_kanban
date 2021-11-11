import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';

import '../card_state_queries.dart';

class KanbanController {
  static List<CardState> listCardState = CardStateQueries.getAllCardsState();
  static List<KanbanCard> getKanbanCardsFromStatus(
      CardState cardState, bool ordered) {
    return CardsQueries.getKanbanCardsFromStatus(cardState.stateId, ordered);
  }

  static void updateCardPosition(KanbanCard kanbanCard, int newPosition) {
    CardsQueries.updatePosition(kanbanCard.cardId, newPosition);
  }
}
