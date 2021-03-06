import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/db/handling_database.dart';
import 'package:simple_kanban/db/priorities_queries.dart';
import 'package:simple_kanban/db/rol_queries.dart';
import 'package:simple_kanban/db/teams_queries.dart';
import 'package:simple_kanban/db/users_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';

class BoardProvider with ChangeNotifier {
  User? currentUser;
  late UsersRol currentUserRol;
  List<CardState> listCardState = [];
  List<Priority> listPriorities = [];
  List<User> listUsers = [];
  List<Team> listTeams = [];
  List<Rol> listRol = [];
  List<List<KanbanCard>> listKanbanCard = [];

  initBoard() {
    final username = Platform.environment['USERNAME'];
  
    currentUser = HandlingDatabase.getUserFromSsytemName(username);

    if (currentUser != null) {
      final rol = HandlingDatabase.getRol(currentUser!.rol.rolId);
      currentUserRol = UsersRol.values[int.parse(rol.rolId)];
      listCardState = HandlingDatabase.getStatesFromUser(currentUser!);
      listKanbanCard =
          HandlingDatabase.getKanbanCardsFromListState(listCardState);

      listPriorities = HandlingDatabase.getAllPriorities();
      listUsers =HandlingDatabase.getAllUsers();
      listTeams = HandlingDatabase.getAllTeam();
      listRol = HandlingDatabase.getAllRol();
    } 
  }

  void updateCardPosition(KanbanCard kanbanCard, int newPosition) {
    CardsQueries.updatePosition(kanbanCard.cardId, newPosition);
  }

  void updateStatePosition(CardState cardState, int newPosition) {
    CardStateQueries.setPosition(cardState.stateId, newPosition);
  }

  Priority? getDefaultPriority() {
    return PrioritiesQueries.getDefaultPriority();
  }

  void updateCardState(CardState cardState) {
    CardStateQueries.updateCardState(cardState);
    notifyListeners();
  }

  void addCardState(CardState cardState) {
    listCardState.add(cardState);
    CardStateQueries.insertCardState(cardState);

    notifyListeners();
  }

  List<KanbanCard> getKanbanCardsFromStatus(CardState cardState, bool ordered) {
    return CardsQueries.getKanbanCardsFromState(cardState.stateId, ordered);
  }

  String? _newStateWhenDelete;

  String? get newStateWhenDelete => _newStateWhenDelete;

  set newStateWhenDelete(String? value) {
    _newStateWhenDelete = value;
    notifyListeners();
  }

  void deleteCardState(CardState cardState) {
    final listKanbanCards = getKanbanCardsFromStatus(cardState, true);

    if (_newStateWhenDelete != null) {
      final newCardState =
          CardStateQueries.getCardsStateFromName(_newStateWhenDelete);
      final int initialNewPositon =
          CardsQueries.getKanbanCardsFromState(newCardState!.stateId, false)
              .length;
      for (int i = 0; i < listKanbanCards.length; i++) {
        CardsQueries.updateState(
            listKanbanCards[i].cardId, newCardState.stateId);
        //TODO: Falta hay que ver mas detenidamente si esto funciona bien
        CardsQueries.updatePosition(
            listKanbanCards[i].cardId, i + initialNewPositon);
      }

      _newStateWhenDelete = null;
    } else {
      for (var l in listKanbanCards) {
        CardsQueries.deleteCard(l.cardId);
      }
    }

    for (int i = cardState.position + 1; i < listCardState.length; i++) {
      int newPosition = listCardState[i].position - 1;
      listCardState[i].copyWith(position: newPosition);
      CardStateQueries.updatePosition(listCardState[i], newPosition);
    }

    CardStateQueries.deleteCardState(cardState.stateId);

    notifyListeners();
  }

  void deleteKanbanCard(KanbanCard kanbanCard) {
    CardsQueries.deleteCard(kanbanCard.cardId);
    notifyListeners();
  }

  Color _backgroundKanbanColor = Colors.white;

  Color get backgroundKanbanColor => _backgroundKanbanColor;

  set backgroundKanbanColor(Color value) {
    _backgroundKanbanColor = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  CardState? getCardStateFromName(String name) {
    return CardStateQueries.getCardsStateFromName(name);
  }

  Priority? getPriorityFromName(String name) {
    return PrioritiesQueries.getPriorityFromName(name);
  }

  User? getUserFromName(String name) {
    return UsersQueries.getUserFromSystemName(name);
  }

  Team? getTeamFromName(String name) {
    return TeamsQueries.getTeamFromName(name);
  }

  void addKanbanCard(KanbanCard kanbanCard) {
    CardsQueries.insertKanbanCard(kanbanCard);
    notifyListeners();
  }

  void updateKanbanCard(KanbanCard kanbanCard) {
    CardsQueries.updateKanbanCard(kanbanCard);
    notifyListeners();
  }

  Rol getRolFromName(String name) {
    return RolQueries.getRolFromName(name);
  }

  void insertUser(User newUser) {
    UsersQueries.insertUser(newUser);
    notifyListeners();
  }

  void updateUser(User newUser) {
    UsersQueries.updateUser(newUser);
    notifyListeners();
  }

  void deleteUser(User newUser) {
    CardsQueries.deleteCardsFromUser(newUser.userId);
    UsersQueries.deleteUser(newUser);

    notifyListeners();
  }
}
