import 'dart:io';

import 'package:simple_kanban/models/rol.dart';

import 'package:sqlite3/sqlite3.dart' as sqlite;

class RolQueries {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  // return 0 Ok
  //return -1 ID exist
  // return -2 name exist
  static int insertRol(Rol rol) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    String sql = 'select * from rol where name="${rol.name}"';
    sqlite.ResultSet result = db.select(sql);
    if (result.isNotEmpty) {
      db.dispose();
      return -2;
    }

    sql = 'select * from rol where rol_id="${rol.rolId}"';
    result = db.select(sql);
    if (result.isEmpty) {
      final String rolId = rol.rolId;
      final String name = rol.name;
      final String description = rol.description ?? '';

      final stmt =
          db.prepare('INSERT INTO rol (rol_id,name,description) VALUES(?,?,?)');
      stmt.execute([rolId, name, description]);
      db.dispose();
      return 0;
    }
    db.dispose();
    return -1;
  }

  static List<Rol> getAllRol() {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from rol');
    List<Rol> rol = [];

    for (var r in result) {
      // String id = r['rol_id'];
      // String name = r['name'];
      // String description = r['description'] ?? '';

      // rol.add(Rol(rolId: id, name: name, description: description));
      rol.add(_rowToRol(r));
    }

    db.dispose();
    return rol;
  }

  static Rol getRol(String id) {
    sqlite.Database db = sqlite.sqlite3.open(finalPath);

    sqlite.ResultSet result = db.select('select * from rol where rol_id="$id"');

    for (var r in result) {
      db.dispose();
      return _rowToRol(r);
    }

    result = db.select('select * from rol');

    // String rolId = result.first['rol_id'];
    // String name = result.first['name'];
    // String description = result.first['description'] ?? '';
    // db.dispose();
    // return Rol(rolId: rolId, name: name, description: description);

    db.dispose();
    return _rowToRol(result.first);
  }

  static Rol _rowToRol(sqlite.Row r) {
    String rolId = r['rol_id'];
    String name = r['name'];
    String description = r['description'] ?? '';
    return Rol(rolId: rolId, name: name, description: description);
  }
}
