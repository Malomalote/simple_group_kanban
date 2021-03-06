import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/menu_provider.dart';

import 'package:simple_kanban/views/conditional_navigation.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: ConditionalNavigation(),
      ),
    );
  }
}
