import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

class KanbanDatabase {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  static void initDatabase() {
    Database db = sqlite3.open(finalPath);
    db.execute('''
      CREATE TABLE IF NOT EXISTS "card_state" (
        "state_id"	TEXT NOT NULL UNIQUE,
        "name"	TEXT NOT NULL UNIQUE,
        "position" INTEGER NOT NULL,
        "description"	TEXT,
        PRIMARY KEY("state_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "priority" (
        "priority_id"	TEXT NOT NULL UNIQUE,
        "name"	TEXT NOT NULL UNIQUE,
        "priority_color"	INTEGER NOT NULL,
        PRIMARY KEY("priority_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "rol" (
        "rol_id"	TEXT NOT NULL UNIQUE,
        "name"	TEXT NOT NULL UNIQUE,
        "description"	TEXT,
        PRIMARY KEY("rol_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "team" (
        "team_id"	TEXT NOT NULL UNIQUE,
        "name"	TEXT NOT NULL UNIQUE,
        "description"	TEXT,
        PRIMARY KEY("team_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "user" (
        "user_id"	TEXT NOT NULL UNIQUE,
        "name"	TEXT NOT NULL,
        "rol"	TEXT NOT NULL,
        FOREIGN KEY("rol") REFERENCES "rol"("rol_id"),
        PRIMARY KEY("user_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "user_team" (
        "user_id"	TEXT NOT NULL,
        "team_id"	TEXT NOT NULL,
        FOREIGN KEY("team_id") REFERENCES "teams"("team_id"),
        FOREIGN KEY("user_id") REFERENCES "users"("user_id")
      )
     ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS "kanban_card" (
        "card_id"	TEXT NOT NULL UNIQUE,
        "creator"	TEXT NOT NULL,
        "creation_date"	TEXT NOT NULL,
        "user_asigned"	TEXT NOT NULL,
        "team_asigned"	TEXT,
        "card_state"	TEXT NOT NULL,
        "state_date"	TEXT NOT NULL,
        "priority"	TEXT NOT NULL,
        "title"	TEXT NOT NULL,
        "description"	TEXT,
        "expiration_date"	TEXT,
        "comments"	TEXT,
        "card_color"	INTEGER NOT NULL,
        "position" INTEGER NOT NULL,
        FOREIGN KEY("user_asigned") REFERENCES "user"("user_id"),
        FOREIGN KEY("team_asigned") REFERENCES "team"("team_id"),
        FOREIGN KEY("card_state") REFERENCES "card_state"("state_id"),
        FOREIGN KEY("priority") REFERENCES "priority"("priority_id"),
        FOREIGN KEY("creator") REFERENCES "user"("user_id"),
        PRIMARY KEY("card_id")
      )
     ''');
    db.dispose();
  }
}
