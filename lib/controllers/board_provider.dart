import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/db/priorities_queries.dart';
import 'package:simple_kanban/db/teams_queries.dart';
import 'package:simple_kanban/db/users_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';

class BoardProvider with ChangeNotifier {
  User? currentUser;
  late List<CardState> listCardState;
  late List<Priority> listPriorities;
  late List<User> listUsers;
  late List<Team> listTeams;
  List<List<KanbanCard>> listKanbanCard = [];
  Future<void> initBoard() async {
    listCardState = CardStateQueries.getAllCardsState(ordered: true);
    for (var l in listCardState) {
      listKanbanCard
          .add(CardsQueries.getKanbanCardsFromStatus(l.stateId, true));
    }
    listPriorities=PrioritiesQueries.getAllPriorities();
    listUsers=UsersQueries.getAllUsers();
    listTeams = TeamsQueries.getAllTeam();
    final username=Platform.environment['USERNAME'];
    currentUser=UsersQueries.getUserFromSystemName(username);
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

        final state = listCardState.removeAt(position);
        listCardState.insert(position + 1, state);
        final item = listKanbanCard.removeAt(position);
        listKanbanCard.insert(position + 1, item);
      }
    } else {
      int position = cardState.position;
      CardState? neighbour =
          CardStateQueries.getCardStateFromPosition(position - 1);
      if (neighbour != null) {
        CardStateQueries.setPosition(cardState.stateId, position - 1);
        CardStateQueries.setPosition(neighbour.stateId, position);
        final state = listCardState.removeAt(position);
        listCardState.insert(position - 1, state);
        final item = listKanbanCard.removeAt(position);
        listKanbanCard.insert(position - 1, item);
      }
    }
    
    notifyListeners();
  }

  void updateCardPosition(KanbanCard kanbanCard, int newPosition) {
    CardsQueries.updatePosition(kanbanCard.cardId, newPosition);
  }

  Priority? getDefaultPriority(){
   return PrioritiesQueries.getDefaultPriority();
  }

  // void updateCardState(KanbanCard kanbanCard,String newState){
  //   CardsQueries.updateState()
  // }
}
