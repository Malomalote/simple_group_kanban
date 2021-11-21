import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/users_provider.dart';
import 'package:simple_kanban/views/widgets/custom_alert_title.dart';

class NewUserDialog extends StatelessWidget {
  const NewUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      title: CustomAlertTitle(title: 'Añadir un nuevo usuario'),
      content: _NewUserForm(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {
            //TODO: Falta acciones para guardar en base de datos
            // if (CardStateProvider.stateGlobalKey.currentState!.validate() &&
            //     CardStateProvider.nameState.isNotEmpty) {
            //   showDialog(
            //       context: context,
            //       builder: (BuildContext context) =>
            //           _ModifyStateDialog(cardState: cardState));
            // }
          },

          //  () => Navigator.pop(context, 'OK'),
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
    final boardProvider = Provider.of<BoardProvider>(context);
    final listSystemUsersName = boardProvider.listUsers
        .map((e) => e.systemName.trim().toLowerCase())
        .toList();
    final listUsersName = boardProvider.listUsers
        .map((e) => e.name.trim().toLowerCase())
        .toList();

    final listRol = boardProvider.listRol.map((e) => e.name).toList();
    String rolDropDownValue = listRol[0];

    return SingleChildScrollView(
      child: SizedBox(
        width: 300,
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
                  if (nameController.text.isEmpty ||
                      nameController.text.length > 40) {
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
                          systemNameController.text = '';
                          UsersProvider.systemName = '';
                        }),
                    labelText:
                        'Este es el nombre que se mostrará en la aplicación (max 40).',
                    hintStyle: const TextStyle(fontSize: 10)),
                onChanged: (value) {
                  UsersProvider.systemName = value;
                },
                validator: (_) {
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
              DropdownButton<String>(
                value: rolDropDownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
                elevation: 16,
                underline: Container(height: 1, color: Colors.deepPurpleAccent),
                onChanged: (String? newValue) {},
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
