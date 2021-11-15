import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/priorities_queries.dart';
import 'package:simple_kanban/db/teams_queries.dart';
import 'package:simple_kanban/db/users_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class CardsQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  //return -1 ID exist
  static int insertKanbanCard(KanbanCard card) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from kanban_card where card_id="${card.cardId}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isEmpty) {
      final String cardId = card.cardId;
      final String creator = card.creator.userId;
      final String creationDate = card.creationDate.toString();
      final String userAsigned = card.userAsigned.userId;
      String? teamAsigned;

      teamAsigned = card.teamAsigned?.teamId ?? '';

      final String cardState = card.cardState.stateId;
      final String stateDate = card.stateDate.toString();
      final String priority = card.priority.priorityId;
      final String title = card.title;
      final String description = card.description ?? '';
      final String expirationDate = card.expirationDate?.toString() ?? '';
      final String private = card.private;
      final int cardColor = Utils.colorToInt(card.cardColor);
      final int position = card.position;

      final stmt = db.prepare(
          'INSERT INTO kanban_card (card_id, creator, creation_date, user_asigned,team_asigned, card_state, state_date, priority, title, description,expiration_date, private, card_color,position) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
      stmt.execute([
        cardId,
        creator,
        creationDate,
        userAsigned,
        teamAsigned,
        cardState,
        stateDate,
        priority,
        title,
        description,
        expirationDate,
        private,
        cardColor,
        position
      ]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<KanbanCard> getAllKanbanCards(bool ordered) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String query = '';
    (ordered)
        ? query = 'select * from kanban_card order by position'
        : query = 'select * from kanban_card';

    sqlite.ResultSet result = db.select(query);
    List<KanbanCard> kanbanCards = [];

    for (var r in result) {
      KanbanCard? newCard = _rowToKanbanCard(r);
      if (newCard != null) {
        kanbanCards.add(newCard);
      }
    }

    db.dispose();
    return kanbanCards;
  }

  static KanbanCard? getKanbanCard(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from kanban_card where card_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToKanbanCard(r);
    }

    db.dispose();
    return null;
  }

  static List<KanbanCard> getKanbanCardsFromStatus(
      String stateId, bool ordered) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String query = '';
    (ordered)
        ? query =
            'select * from kanban_card where card_state="$stateId" order by position'
        : query = 'select * from kanban_card where card_state="$stateId"';

    sqlite.ResultSet result = db.select(query);

    List<KanbanCard> kanbanCards = [];

    for (var r in result) {
      KanbanCard? newCard = _rowToKanbanCard(r);
      if (newCard != null) {
        kanbanCards.add(newCard);
      }
    }

    db.dispose();
    return kanbanCards;
  }

  static KanbanCard? _rowToKanbanCard(sqlite.Row r) {
    String cardId = r['card_id'];

    User? creator = UsersQueries.getUser(r['creator']);
    if (creator == null) return null;

    DateTime creationDate = DateTime.parse(r['creation_date']);
    User? userAsigned = UsersQueries.getUser(r['user_asigned']);
    if (userAsigned == null) return null;

    Team? teamAsigned = TeamsQueries.getTeam(r['team_asigned']);
    CardState? cardState = CardStateQueries.getCardsState(r['card_state']);
    if (cardState == null) return null;
    DateTime stateDate = DateTime.parse(r['state_date']);
    Priority? priority = PrioritiesQueries.getPriority(r['priority']);
    if (priority == null) return null;
    String title = r['title'];
    String? description = r['description'];
    DateTime? expirationDate;
    if (r['expiration_date'] != '') {
      expirationDate = DateTime.parse(r['expiration_date']);
    }
    String private = r['private'];
    Color cardColor = Color(r['card_color']);
    int position = r['position'];
    return KanbanCard(
        cardId: cardId,
        creator: creator,
        creationDate: creationDate,
        userAsigned: userAsigned,
        teamAsigned: teamAsigned,
        cardState: cardState,
        stateDate: stateDate,
        priority: priority,
        title: title,
        description: description,
        expirationDate: expirationDate,
        private: private,
        cardColor: cardColor,
        position: position);
  }

  static void updateColor(String id, Color color) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query =
        'update kanban_card set card_color=${Utils.colorToInt(color)} where card_id="$id"';
    db.execute(query);
    db.dispose();
  }

  static void updatePosition(String id, int newPosition) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query =
        'update kanban_card set position=$newPosition where card_id="$id"';
    db.execute(query);
    db.dispose();
  }
}
