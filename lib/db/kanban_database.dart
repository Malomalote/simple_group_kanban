import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/db/priorities_queries.dart';
import 'package:simple_kanban/db/rol_queries.dart';
import 'package:simple_kanban/db/users_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:sqlite3/sqlite3.dart';

class KanbanDatabase {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  static void initDatabase({required String systemName,required String userName}) {
    if (!File(finalPath).existsSync()) {
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
        "system_name" TEXT NOT NULL UNIQUE,
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
        "private"	TEXT NOT NULL,
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

      Rol userRol = Rol(
          rolId: '1',
          name: 'Usuario',
          description:
              'Usuario sin privilegios, puede crear tareas, editar las de su correspondiente grupo y marcar como finalizada');
      RolQueries.insertRol(userRol);

      Rol sectionBossRol = Rol(
          rolId: '2',
          name: 'Jefe de sección',
          description:
              'Usuario con ciertos privilegios, puede cambiar tareas a una sección distinta a aquellas a las que pertenece.');
      RolQueries.insertRol(sectionBossRol);
      Rol bossRol = Rol(
          rolId: '3',
          name: 'Jefe',
          description:
              'Usuario con privilegios avanzados, puede añadir secciones nuevas, añadir tareas en todas las secciones, etc...');
      RolQueries.insertRol(bossRol);
      Rol adminRol = Rol(
          rolId: '4',
          name: 'Administrador',
          description: 'Usuario con todos los privilegios.');
      RolQueries.insertRol(adminRol);

      
      User adminUser= User(userId: '0', name: userName, rol: adminRol, systemName: systemName);
      UsersQueries.insertUser(adminUser);

      CardState cardStatePending = CardState(
          stateId: '0',
          name: 'Pendiente',
          description: 'Incluir en esta columna las tareas pendientes.',
          position: 0);
      CardStateQueries.insertCardState(cardStatePending);
      CardState cardStateProcessing = CardState(
          stateId: '1',
          name: 'En ejecución',
          description:
              'En esta columna se incluyen las tareas que están en proceso.',
          position: 1);
      CardStateQueries.insertCardState(cardStateProcessing);
      CardState cardStateEnd = CardState(
          stateId: '2',
          name: 'Finalizada',
          description: 'Las tareas realizadas se sitúan en esta columna.',
          position: 2);
      CardStateQueries.insertCardState(cardStateEnd);

      Priority priorityLow =
          Priority(priorityId: '0', name: 'Baja', priorityColor: Colors.green);
      PrioritiesQueries.insertPriority(priorityLow);
      Priority priorityMedium = Priority(
          priorityId: '1', name: 'Media', priorityColor: Colors.orange);
      PrioritiesQueries.insertPriority(priorityMedium);
      Priority priorityHigh =
          Priority(priorityId: '2', name: 'Alta', priorityColor: Colors.red);
      PrioritiesQueries.insertPriority(priorityHigh);
      KanbanCard kanbanCardPending =KanbanCard(cardId: '0', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStatePending, stateDate: DateTime.now(), priority: priorityMedium, title: 'Tarea pendiente de realizar.', private: 'false', cardColor: kanbanColors[5], position: 0,description: 'Tarea de ejemplo');
      CardsQueries.insertKanbanCard(kanbanCardPending);
      KanbanCard kanbanCardProcessing =KanbanCard(cardId: '1', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStateProcessing, stateDate: DateTime.now(), priority: priorityHigh, title: 'Tarea en proceso. Ya mismo estará terminada.', private: 'false', cardColor: kanbanColors[3], position: 0,description: 'Tarea de ejemplo');
      CardsQueries.insertKanbanCard(kanbanCardProcessing);
      KanbanCard kanbanCardEnd =KanbanCard(cardId: '2', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStateEnd, stateDate: DateTime.now(), priority: priorityLow, title: 'Tarea finalizada.', private: 'false', cardColor: kanbanColors[0], position: 0,description: 'Tarea de ejemplo');
      CardsQueries.insertKanbanCard(kanbanCardEnd);




      db.dispose();
    }
  }
}
