import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/users_provider.dart';
import 'package:simple_kanban/views/widgets/custom_alert_title.dart';

class NewUserDialog extends StatelessWidget {
  const NewUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    UsersProvider.rol =
        boardProvider.getRolFromName(boardProvider.listRol[0].name);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      title: const CustomAlertTitle(title: 'Añadir un nuevo usuario'),
      content: const _NewUserForm(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {
            if (UsersProvider.userGlobalKey.currentState!.validate() &&
                UsersProvider.systemName != null &&
                UsersProvider.systemName!.isNotEmpty &&
                UsersProvider.name != null &&
                UsersProvider.name!.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const _AddUserDialog());
            }
          },
          child: const Text('OK',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _NewUserForm extends StatefulWidget {
  const _NewUserForm({Key? key}) : super(key: key);

  @override
  State<_NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<_NewUserForm> {
  TextEditingController systemNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    systemNameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final listSystemUsersName = boardProvider.listUsers
        .map((e) => e.systemName.trim().toLowerCase())
        .toList();
    final listUsersName = boardProvider.listUsers
        .map((e) => e.name.trim().toLowerCase())
        .toList();

    final listRol = boardProvider.listRol.map((e) => e.name).toList();
    String rolDropDownValue = UsersProvider.rol!.name;

    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: UsersProvider.userGlobalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                maxLength: 40,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: systemNameController,
                decoration: InputDecoration(
                    hintText: 'Usuario del sistema.',
                    suffixIcon: GestureDetector(
                        child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.clear_rounded,
                                color: Colors.grey, size: 14)),
                        onTap: () {
                          systemNameController.text = '';
                          UsersProvider.systemName = '';
                        }),
                    labelText: 'Se usa para identificación (max 40).',
                    hintStyle: const TextStyle(fontSize: 10)),
                onChanged: (value) {
                  UsersProvider.systemName = value;
                },
                validator: (_) {
                  if (listSystemUsersName.contains(
                      systemNameController.text.trim().toLowerCase())) {
                    return 'El usuario ya existe';
                  }
                  if (systemNameController.text.isEmpty ||
                      systemNameController.text.length > 40) {
                    return 'Debe contener entre 1 y 40 caracteres';
                  }
                },
              ),
              TextFormField(
                autocorrect: false,
                maxLength: 40,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Nombre del usuario.',
                    suffixIcon: GestureDetector(
                        child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.clear_rounded,
                                color: Colors.grey, size: 14)),
                        onTap: () {
                          nameController.text = '';
                          UsersProvider.name = '';
                        }),
                    labelText:
                        'Este es el nombre que se mostrará en la aplicación (max 40).',
                    hintStyle: const TextStyle(fontSize: 10)),
                onChanged: (value) {
                  UsersProvider.name = value;
                },

              ),
              DropdownButton<String>(
                value: rolDropDownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
                elevation: 16,
                underline: Container(height: 1, color: Colors.deepPurpleAccent),
                onChanged: (String? newValue) {
                  setState(() {
                    rolDropDownValue = newValue!;
                    UsersProvider.rol = boardProvider.getRolFromName(newValue);
                  });
                },
                items: listRol
                    .map((e) => e)
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddUserDialog extends StatelessWidget {
  const _AddUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const CustomAlertTitle(title: 'Añadir Usuario '),
          content: Column(
            children: [
              const Text('Se va a añadir el Usuario:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.name!),
              const Text('Usuario para autenticación:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.systemName!),
              const Text('Perfil:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.rol!.name),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                boardProvider.insertUser(UsersProvider.getUser());
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
