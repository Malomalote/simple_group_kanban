import 'package:flutter/material.dart';
import 'package:simple_kanban/views/home_view.dart';

import 'db/kanban_database.dart';

void main() {
  KanbanDatabase.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomeView(),
    );
  }
}
