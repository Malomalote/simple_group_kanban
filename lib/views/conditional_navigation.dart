import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/handling_database.dart';
import 'package:simple_kanban/views/home_view.dart';
import 'package:simple_kanban/views/instalation_view.dart';
import 'package:simple_kanban/views/widgets/user_error.dart';

class ConditionalNavigation extends StatefulWidget {
  const ConditionalNavigation({Key? key}) : super(key: key);

  @override
  _ConditionalNavigationState createState() => _ConditionalNavigationState();
}

class _ConditionalNavigationState extends State<ConditionalNavigation> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    // Timer(Duration(milliseconds: 200), () {
    Timer(Duration.zero, () {
      conditionalNavigation(); //It will redirect  after 3 seconds
    });
  }

  void conditionalNavigation() async {
    final String finalPath =
        Directory.current.path + Platform.pathSeparator + 'kanban.db';
    final fileExists = File(finalPath).existsSync();
    if (fileExists) {
      final username = Platform.environment['USERNAME'];

      if (HandlingDatabase.getUserFromSsytemName(username) == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserError()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const InstalationView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
          child: Text(
        'KanbanCard v.01',
        style: TextStyle(
            fontSize: 34,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      )),
    );
  }
}
