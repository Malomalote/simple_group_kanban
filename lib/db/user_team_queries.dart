import 'dart:io';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:sqlite3/sqlite3.dart';

class UserTeamQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  static int insertUserTeam(User user, Team team) {
    Database db = sqlite3.open(finalPath);

    final String userId = user.userId;
    final String teamId = team.teamId;

    final stmt =
        db.prepare('INSERT INTO user_team (user_id, team_id) VALUES(?,?)');
    stmt.execute([userId, teamId]);
    db.dispose();
    return 0;
  }
}
