import 'dart:io';

import 'package:simple_kanban/models/card_state.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class CardStateQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  //return -1 ID exist
  // return -2 name exist
  static int insertCardState(CardState cardState) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from card_state where name="${cardState.name}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isNotEmpty) {
      db.dispose();
      return -2;
    }

    sql = 'select * from card_state where state_id="${cardState.stateId}"';
    result = db.select(sql);
    if (result.isEmpty) {
      final String stateId = cardState.stateId;
      final String name = cardState.name;
      final String description = cardState.description ?? '';
      final int position = cardState.position;

      final stmt = db.prepare(
          'INSERT INTO card_state (state_id,name,description,position) VALUES(?,?,?,?)');
      stmt.execute([stateId, name, description, position]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<CardState> getAllCardsState({required bool ordered}) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String query = '';
    (ordered)
        ? query = 'select * from card_state order by position'
        : query = 'select * from card_state';
    sqlite.ResultSet result = db.select(query);

    List<CardState> cardState = [];

    for (var r in result) {
      db.dispose();
      cardState.add(_rowToCardState(r));
    }

    db.dispose();
    return cardState;
  }

  static CardState? getCardsState(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from card_state where state_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToCardState(r);
    }

    db.dispose();
    return null;
  }

  static CardState? getCardStateFromPosition(int position) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from card_state where position=$position');

    for (var r in result) {
      db.dispose();
      return _rowToCardState(r);
    }

    db.dispose();
    return null;
  }

  static CardState? getCardsStateFromName(String? name) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from card_state where name="$name"');

    for (var r in result) {
      db.dispose();
      return _rowToCardState(r);
    }

    db.dispose();
    return null;
  }

  static void setPosition(String id, int newPosition) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query =
        'update card_state set position=$newPosition where state_id="$id"';
    db.execute(query);
    db.dispose();
  }

  static void updateCardState(CardState cardState) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query =
        'update card_state set name="${cardState.name}",description="${cardState.description}" where state_id="${cardState.stateId}"';
    db.execute(query);
    db.dispose();
  }

  static void deleteCardState(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query = 'DELETE FROM card_state where state_id="$id"';
    db.execute(query);
    db.dispose();
  }

  static void updatePosition(CardState cardState, int newPosition) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);
    String query =
        'update card_state set position=$newPosition where state_id="${cardState.stateId}"';
    db.execute(query);
    db.dispose();
  }

  static CardState _rowToCardState(sqlite.Row r) {
    String id = r['state_id'];
    String name = r['name'];
    String description = r['description'] ?? '';
    int position = r['position'];

    return CardState(
        stateId: id, name: name, description: description, position: position);
  }
}
