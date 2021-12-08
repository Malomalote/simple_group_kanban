import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/users_provider.dart';
import 'package:simple_kanban/views/widgets/custom_alert_title.dart';

class UpdateUserDialog extends StatelessWidget {
  const UpdateUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      title: const CustomAlertTitle(title: 'Modificar Usuario'),
      content: const _UpdateUserForm(),
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
                UsersProvider.name!.isNotEmpty &&
                UsersProvider.rol != null &&
                UsersProvider.rol!.name.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const _UpdateUserDialog());
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

class _UpdateUserForm extends StatefulWidget {
  const _UpdateUserForm({Key? key}) : super(key: key);

  @override
  State<_UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<_UpdateUserForm> {
  TextEditingController nameController = TextEditingController();
  late bool canChangeName;
  String rolDropdownValue = '';
  String systemNameDropDownValue = '';
  @override
  void initState() {
    canChangeName = false;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);

    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: UsersProvider.userGlobalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              DropdownButton<String>(
                  value: systemNameDropDownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  underline:
                      Container(height: 1, color: Colors.deepPurpleAccent),
                  onChanged: (String? newValue) {
                    setState(() {
                      systemNameDropDownValue = newValue!;
                      if (newValue != '') {
                        UsersProvider.initUserProvider(boardProvider.listUsers
                            .firstWhere(
                                (element) => element.systemName == newValue));
                        rolDropdownValue = UsersProvider.rol!.name;
                        nameController.text = UsersProvider.name!;
                        canChangeName = true;
                        // listUsersName.remove(UsersProvider.name!);
                        // print(listUsersName.length);
                      } else {
                        rolDropdownValue = '';
                        canChangeName = false;
                        nameController.text = '';
                      }
                    });
                  },
                  items: [
                    const DropdownMenuItem(value: '', child: Text('')),
                    ...boardProvider.listUsers
                        .map((e) => e.systemName)
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ]),
              TextFormField(
                autocorrect: false,
                maxLength: 40,
                enabled: canChangeName,
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
                validator: (_) {
                  List<String> listUsersName = boardProvider.listUsers
                      .where((element) => element.name != UsersProvider.name)
                      .map((e) => e.name.trim().toLowerCase())
                      .toList();

                  if (listUsersName
                      .contains(nameController.text.trim().toLowerCase())) {
                    return 'El nombre de usuario ya existe';
                  }
                  if (nameController.text.isEmpty ||
                      nameController.text.length > 40) {
                    return 'Debe contener entre 1 y 40 caracteres';
                  }
                },
              ),
              if (canChangeName)
                DropdownButton<String>(
                    value: rolDropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    underline:
                        Container(height: 1, color: Colors.deepPurpleAccent),
                    onChanged: (String? newValue) {
                      setState(() {
                        rolDropdownValue = newValue!;
                        UsersProvider.rol =
                            boardProvider.getRolFromName(newValue);
                      });
                    },
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text(''),
                      ),
                      ...boardProvider.listRol
                          .map((e) => e.name)
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdateUserDialog extends StatelessWidget {
  const _UpdateUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const CustomAlertTitle(title: 'Actualizar Usuario '),
          content: Column(
            children: [
              const Text('Se va a actualizar el Usuario:',
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
                boardProvider.updateUser(UsersProvider.getUser());
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
