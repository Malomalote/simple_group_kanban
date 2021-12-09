import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/db/priorities_queries.dart';
import 'package:simple_kanban/db/rol_queries.dart';
import 'package:simple_kanban/db/teams_queries.dart';
import 'package:simple_kanban/db/user_team_queries.dart';
import 'package:simple_kanban/db/users_queries.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';

class HandlingDatabase {
  ///////////ROL queries
  static insertRol(Rol rol) {
    RolQueries.insertRol(rol);
  }

  static Rol getRol(String idRol) {
    return RolQueries.getRol(idRol);
  }
  
  static List<Rol> getAllRol(){
    return RolQueries.getAllRol();
  }

///////////USER queries
  static insertUser(User user) {
    UsersQueries.insertUser(user);
  }

  static User? getUserFromSsytemName(String? userSystemName) {
    return UsersQueries.getUserFromSystemName(userSystemName);
  }

  static List<User> getAllUsers() {
    return UsersQueries.getAllUsers();
  }

///////////TEAM queries
  static insertTeam(Team team) {
    TeamsQueries.insertTeam(team);
  }
  static List<Team>  getAllTeam(){
    return TeamsQueries.getAllTeam();
  }
///////////USER-TEAM queries
  static insertUserTeam(User user, Team team) {
    UserTeamQueries.insertUserTeam(user, team);
  }


///////////CARD STATE queries
  static insertCardState(CardState cardState) {
    CardStateQueries.insertCardState(cardState);
  }

  static List<CardState> getStatesFromUser(User user) {
    UsersRol userRol = UsersRol.values[int.parse(user.rol.rolId)];

    if (userRol == UsersRol.admin || userRol == UsersRol.boss) {
      return CardStateQueries.getAllCardsState(ordered: true);
    }
    //TODO: Falta poner filtro para que solo se vean a las que tiene acceso el usuario
    return CardStateQueries.getAllCardsState(ordered: true);
  }

///////////PRIORITY queries
  static insertPriority(Priority priority) {
    PrioritiesQueries.insertPriority(priority);
  }

  static List<Priority> getAllPriorities() {
    return PrioritiesQueries.getAllPriorities();
  }

///////////CARDS queries
  static insertKanbanCard(KanbanCard kanbanCard) {
    CardsQueries.insertKanbanCard(kanbanCard);
  }

  static List<List<KanbanCard>> getKanbanCardsFromListState(
      List<CardState> cardState) {
    List<String> listState = cardState.map((e) => e.stateId).toList();
    return CardsQueries.getKanbanCardsFromListState(listState);
  }
}
