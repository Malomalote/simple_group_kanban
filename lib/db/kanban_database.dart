import 'dart:io';

import 'package:flutter/material.dart';

import 'package:simple_kanban/db/handling_database.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:sqlite3/sqlite3.dart';

class KanbanDatabase {
  static final String finalPath =
      Directory.current.path + Platform.pathSeparator + 'kanban.db';

  static void initSqlite3Database({required String systemName,required String userName}) {
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
          rolId: '0',
          name: 'Usuario',
          description:
              'Usuario sin privilegios, puede crear tareas, editar las de su correspondiente grupo y marcar como finalizada');
      HandlingDatabase.insertRol(userRol);

      Rol departmentBossRol = Rol(
          rolId: '1',
          name: 'Jefe de departamento',
          description:
              'Usuario con ciertos privilegios, puede cambiar tareas a un departamento distinto a aquellos a los que pertenece.');
      HandlingDatabase.insertRol(departmentBossRol);
      Rol bossRol = Rol(
          rolId: '2',
          name: 'Jefe',
          description:
              'Usuario con privilegios avanzados, puede añadir secciones nuevas, añadir tareas en todas las secciones, etc...');
      HandlingDatabase.insertRol(bossRol);
      Rol adminRol = Rol(
          rolId: '3',
          name: 'Administrador',
          description: 'Usuario con todos los privilegios.');
      HandlingDatabase.insertRol(adminRol);

      
      User adminUser= User(userId: '0', name: userName, rol: adminRol, systemName: systemName);
      HandlingDatabase.insertUser(adminUser);

      Team adminTeam=Team(teamId: '0', name: 'Administradores', description:'Grupo de administradores, tienen acceso a todas las funcionalidades de la aplicación');
      HandlingDatabase.insertTeam(adminTeam);

      HandlingDatabase.insertUserTeam(adminUser, adminTeam);

      CardState cardStatePending = CardState(
          stateId: '0',
          name: 'Pendiente',
          description: 'Incluir en esta columna las tareas pendientes.',
          position: 0);
      HandlingDatabase.insertCardState(cardStatePending);
      CardState cardStateProcessing = CardState(
          stateId: '1',
          name: 'En ejecución',
          description:
              'En esta columna se incluyen las tareas que están en proceso.',
          position: 1);
      HandlingDatabase.insertCardState(cardStateProcessing);
      CardState cardStateEnd = CardState(
          stateId: '2',
          name: 'Finalizada',
          description: 'Las tareas realizadas se sitúan en esta columna.',
          position: 2);
      HandlingDatabase.insertCardState(cardStateEnd);

      Priority priorityLow =
          Priority(priorityId: '0', name: 'Baja', priorityColor: Colors.green);
      HandlingDatabase.insertPriority(priorityLow);
      Priority priorityMedium = Priority(
          priorityId: '1', name: 'Media', priorityColor: Colors.orange);
      HandlingDatabase.insertPriority(priorityMedium);
      Priority priorityHigh =
          Priority(priorityId: '2', name: 'Alta', priorityColor: Colors.red);
      HandlingDatabase.insertPriority(priorityHigh);
      KanbanCard kanbanCardPending =KanbanCard(cardId: '0', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStatePending, stateDate: DateTime.now(), priority: priorityMedium, title: 'Tarea pendiente de realizar.', private: 'false', cardColor: kanbanColors[5], position: 0,description: 'Tarea de ejemplo');
      HandlingDatabase.insertKanbanCard(kanbanCardPending);
      KanbanCard kanbanCardProcessing =KanbanCard(cardId: '1', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStateProcessing, stateDate: DateTime.now(), priority: priorityHigh, title: 'Tarea en proceso. Ya mismo estará terminada.', private: 'false', cardColor: kanbanColors[3], position: 0,description: 'Tarea de ejemplo');
      HandlingDatabase.insertKanbanCard(kanbanCardProcessing);
      KanbanCard kanbanCardEnd =KanbanCard(cardId: '2', creator: adminUser, creationDate: DateTime.now(), userAsigned: adminUser, cardState: cardStateEnd, stateDate: DateTime.now(), priority: priorityLow, title: 'Tarea finalizada.', private: 'false', cardColor: kanbanColors[0], position: 0,description: 'Tarea de ejemplo');
      HandlingDatabase.insertKanbanCard(kanbanCardEnd);




      db.dispose();
    }
  }
}
