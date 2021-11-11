import 'package:flutter/material.dart';
import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/utils/utils.dart';

class BoardProvider with ChangeNotifier {
  List<CardState> _listCardState = [];
  List<CardState> listCardState() {
    _listCardState = CardStateQueries.getAllCardsState(ordered: true);
    Future.delayed(Duration.zero, () async => notifyListeners());
    return _listCardState;
  }
  // List<CardState> listCardState =
  //     CardStateQueries.getAllCardsState(ordered: true);

  List<KanbanCard> _selectedListCards = [];
  List<KanbanCard> getKanbanCardsFromStatus(CardState cardState, bool ordered) {
    _selectedListCards =
        CardsQueries.getKanbanCardsFromStatus(cardState.stateId, ordered);
    Future.delayed(Duration.zero, () async => notifyListeners());
    return _selectedListCards;
  }

  static void updateCardPosition(KanbanCard kanbanCard, int newPosition) {
    CardsQueries.updatePosition(kanbanCard.cardId, newPosition);
  }

  void moveState(
      {required CardState cardState, required CardDirection direction}) {
    if (direction == CardDirection.derecha) {
      int position = cardState.position;
      CardState? neighbour =
          CardStateQueries.getCardStateFromPosition(position + 1);
      if (neighbour != null) {
        CardStateQueries.setPosition(cardState.stateId, position + 1);
        CardStateQueries.setPosition(neighbour.stateId, position);
      }
    } else {
      int position = cardState.position;
      CardState? neighbour =
          CardStateQueries.getCardStateFromPosition(position - 1);
      if (neighbour != null) {
        CardStateQueries.setPosition(cardState.stateId, position - 1);
        CardStateQueries.setPosition(neighbour.stateId, position);
      }
    }
    notifyListeners();
  }
}
