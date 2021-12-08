import 'package:simple_kanban/models/rol.dart';

class User {
  final String userId;
  final String name;
  final Rol rol;
  final String systemName;

  User(
      {required this.userId,
      required this.name,
      required this.rol,
      required this.systemName});
}
