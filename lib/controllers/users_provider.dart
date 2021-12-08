import 'package:flutter/material.dart';
import 'package:nuid/nuid.dart';
import 'package:simple_kanban/models/rol.dart';
import 'package:simple_kanban/models/user.dart';

class UsersProvider {
  static GlobalKey<FormState> userGlobalKey = GlobalKey<FormState>();

  static String? userId;
  static String? systemName;
  static String? name;
  static Rol? rol;
  static bool isNewUser = true;

  static void initUserProvider(User user) {
    userId = user.userId;
    systemName = user.systemName;
    name = user.name;
    rol = user.rol;
    isNewUser = false;
  }

  static User getUser() {
    final String? newId;
    if (isNewUser) {
      Nuid nuid = Nuid.instance;
      newId = nuid.next();
    } else {
      newId = userId;
    }

    User newUser =
        User(userId: newId!, name: name!, rol: rol!, systemName: systemName!);
    return newUser;
  }
}
