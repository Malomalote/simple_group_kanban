import 'dart:io';

import 'package:simple_kanban/models/team.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class TeamsQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  //return -1 ID exist
  // return -2 name exist
  static int insertTeam(Team team) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from team where name="${team.name}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isNotEmpty) {
      db.dispose();
      return -2;
    }

    sql = 'select * from team where team_id="${team.teamId}"';
    result = db.select(sql);
    if (result.isEmpty) {
      final String teamId = team.teamId;
      final String name = team.name;
      final String description = team.description ?? '';

      final stmt = db
          .prepare('INSERT INTO team (team_id,name,description) VALUES(?,?,?)');
      stmt.execute([teamId, name, description]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<Team> getAllTeam() {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from team');
    List<Team> team = [];

    for (var r in result) {
      // String id = r['team_id'];
      // String name = r['name'];
      // String description = r['description'] ?? '';

      team.add(_rowToTeam(
          r)); //Team(teamId: id, name: name, description: description));
    }

    db.dispose();
    return team;
  }

  static Team? getTeam(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from team where team_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToTeam(r);
    }

    db.dispose();
    return null;
  }

  static Team _rowToTeam(sqlite.Row r) {
    String id = r['team_id'];
    String name = r['name'];
    String description = r['description'] ?? '';
    return Team(teamId: id, name: name, description: description);
  }
}
