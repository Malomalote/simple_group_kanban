import 'dart:io';

import 'package:simple_kanban/db/rol_queries.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class UsersQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  static int insertUser(User user) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from user where user_id="${user.userId}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isEmpty) {
      final String userId = user.userId;
      final String name = user.name;
      final String rol = user.rol.rolId;

      final stmt =
          db.prepare('INSERT INTO user (user_id,name,rol) VALUES(?,?,?)');
      stmt.execute([userId, name, rol]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<User> getAllUsers() {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from user');
    List<User> user = [];

    for (var r in result) {
      user.add(_rowToUser(r));
    }

    db.dispose();
    return user;
  }

  static User? getUser(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result =
        db.select('select * from user where user_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToUser(r);
    }

    db.dispose();
    return null;
  }

  static User _rowToUser(sqlite.Row r) {
    String id = r['user_id'];
    String name = r['name'];
    String rolId = r['rol'];

    Rol rol = RolQueries.getRol(rolId);
    return User(userId: id, name: name, rol: rol);
  }
}
