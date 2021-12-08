import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class PrioritiesQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  //return -1 ID exist
  // return -2 name exist
  static int insertPriority(Priority priority) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from priority where name="${priority.name}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isNotEmpty) {
      db.dispose();
      return -2;
    }

    sql = 'select * from priority where priority_id="${priority.priorityId}"';
    result = db.select(sql);
    if (result.isEmpty) {
      final String priorityId = priority.priorityId;
      final String name = priority.name;

      final int priorityColor = Utils.colorToInt(priority.priorityColor);

      final stmt = db.prepare(
          'INSERT INTO priority (priority_id,name,priority_color) VALUES(?,?,?)');
      stmt.execute([priorityId, name, priorityColor]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<Priority> getAllPriorities() {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from priority');
    List<Priority> priorities = [];

    for (var r in result) {
      String id = r['priority_id'];
      String name = r['name'];
      Color priorityColor = Utils.intToColor(r['priority_color']);

      priorities.add(
          Priority(priorityId: id, name: name, priorityColor: priorityColor));
    }

    db.dispose();
    return priorities;
  }

  static Priority? getPriority(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from priority where priority_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToPriority(r);
    }

    db.dispose();
    return null;
  }

  static Priority? getPriorityFromName(String name) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from priority where name="$name"');

    for (var r in result) {
      db.dispose();
      return _rowToPriority(r);
    }

    db.dispose();
    return null;
  }

  static Priority? getDefaultPriority() {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from priority');

    for (var r in result) {
      db.dispose();
      return _rowToPriority(r);
    }

    db.dispose();
    return null;
  }

  static Priority _rowToPriority(sqlite.Row r) {
    String id = r['priority_id'];
    String name = r['name'];
    Color priorityColor = Utils.intToColor(r['priority_color']);

    return Priority(priorityId: id, name: name, priorityColor: priorityColor);
  }
}
