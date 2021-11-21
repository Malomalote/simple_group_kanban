import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/users_provider.dart';
import 'package:simple_kanban/views/widgets/custom_alert_title.dart';

class DeleteUserDialog extends StatelessWidget {
  const DeleteUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      title: const CustomAlertTitle(title: 'Eliminar Usuario'),
      content: const _DeleteUserForm(),
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
                UsersProvider.userId != null &&
                UsersProvider.userId!.isNotEmpty ) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const _DeleteUserDialog());
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

class _DeleteUserForm extends StatefulWidget {
  const _DeleteUserForm({Key? key}) : super(key: key);

  @override
  State<_DeleteUserForm> createState() => _DeleteUserFormState();
}

class _DeleteUserFormState extends State<_DeleteUserForm> {


  String systemNameDropDownValue = '';
  String userName='';
  String userRol='';
  bool showData=false;


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
                       userName=UsersProvider.name!;
                       userRol=UsersProvider.rol!.name;
                        showData=true;
                      } else {
                       userName='';
                       userRol='';
                       showData=false;
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '', child: Text('')),
                    ...boardProvider.listUsers
                        .map((e) => e.systemName)
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  ),
                  if (showData) Column(
                    children: [
                      Text('Nombre de usuario',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userName),
                      Text('Perfil de usuario:',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userRol),
                      SizedBox(height: 10),
                      Text('Si borra este usuario se borrarán las tareas que tenga asignadas.',textAlign : TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    ],
                  ),

            ],
          ),
        ),
      ),
    );
  }
}

//TODO: Falta adaptar esto
class _DeleteUserDialog extends StatelessWidget {
  const _DeleteUserDialog({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    bool canDelete=(boardProvider.listUsers.where((element) => element.rol.name=='Administrador').toList().length>1);
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const CustomAlertTitle(title: 'Borrar Usuario '),
          content: Column(
            children: [

              (canDelete)?
              Column(
                children: [
                                const Text('Se va a borrar el Usuario:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.name!),
              const Text('Usuario para autenticación:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.systemName!),
              const Text('Perfil:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(UsersProvider.rol!.name),
                     SizedBox(height: 10),
                      Text('Recuerde que al borrar el usuario se eliminan las tareas que tenga asignadas.',textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                     Text('¿Está seguro?',textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              ): Column(
                children: [
                  Text(UsersProvider.name!),
                     Text('No puede borrarse porque el sistema debe tener al menos un Administrador',textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                     Text('Antes de borrarlo debe asignar el perfil Administrador a otro usuario',textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              )
              


            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
           if (canDelete)
           TextButton(
              child: const Text('OK',
              
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                boardProvider.deleteUser(UsersProvider.getUser());
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
