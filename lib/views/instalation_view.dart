import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kanban/db/kanban_database.dart';
import 'package:simple_kanban/views/home_view.dart';
import 'package:simple_kanban/views/widgets/custom_input_decoration.dart';

class InstalationView extends StatefulWidget {
  const InstalationView({Key? key}) : super(key: key);

  @override
  State<InstalationView> createState() => _InstalationViewState();
}

class _InstalationViewState extends State<InstalationView> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> installationGlobalKey = GlobalKey<FormState>();
    final systemName = Platform.environment['USERNAME'];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡¡La base de datos no existe!!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Se va a crear una nueva base de datos',
                style: TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            const Text(
                'El usuario actual se va a dar de alta como Administrador',
                style: TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Usuario del sistema: ',
                    style: TextStyle(fontSize: 22)),
                Text('$systemName',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Form(
              key: installationGlobalKey,
              child: SizedBox(
                width: 380,
                child: TextFormField(
                  controller: controller,
                  autocorrect: false,
                  decoration: customInputDecoration(
                      hintText: 'Nombre Usuario',
                      labelText:
                          'Nombre que se mostrará en la aplicación',
                      controller: controller,
                      onTap: () {
                        controller.text = '';
                      }),

                  //  InputDecoration(
                  //   hintText: 'Nombre del usuario.',
                  //   suffixIcon: GestureDetector(
                  //       child: const MouseRegion(
                  //           cursor: SystemMouseCursors.click,
                  //           child: Icon(Icons.clear_rounded,
                  //               color: Colors.grey, size: 14)),
                  //       onTap: () {
                  //         controller.text = '';
                  //       }),
                  //   labelText:
                  //       'Este es el nombre que se mostrará en la aplicación.',
                  //   labelStyle: const TextStyle(fontSize: 15),
                  //   hintStyle: const TextStyle(fontSize: 12),
                  // ),
                  validator: (_) {
                    if (controller.text.trim().isEmpty) {
                      return 'Debe introducir un nombre de usuario';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              color: Colors.blueAccent,
              child:
                  const Text('Iniciar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (installationGlobalKey.currentState!.validate()) {
                  KanbanDatabase.initSqlite3Database(
                      systemName: systemName!,
                      userName: controller.text.trim());
                  Navigator.push(
                      // Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const HomeView()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
