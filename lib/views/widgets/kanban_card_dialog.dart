import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';

import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/utils/utils.dart';

class KanbanCardDialog extends StatelessWidget {
  final KanbanCard kanbanCard;
  KanbanCardDialog({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(8),
      buttonPadding: EdgeInsets.all(1),
      // backgroundColor: kanbanCard.cardColor,
      content: _KanbanForm(kanbanCard: kanbanCard),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _KanbanForm extends StatefulWidget {
  final KanbanCard kanbanCard;
  const _KanbanForm({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  @override
  State<_KanbanForm> createState() => _KanbanFormState();
}

class _KanbanFormState extends State<_KanbanForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String stateDropdownValue = '';
  String priorityDropdownValue = '';
  bool private = false;
  @override
  void initState() {
    super.initState();
    titleController.text = widget.kanbanCard.title;
    descriptionController.text = widget.kanbanCard.description ?? '';
    stateDropdownValue = widget.kanbanCard.cardState.name;
    priorityDropdownValue = widget.kanbanCard.priority.name;
    if (widget.kanbanCard.private == true) private = true;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final _formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Container(
        width: 600,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                maxLength: 100,
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 14),
                controller: titleController,
                decoration: _CustomInputDecoration(
                    hintText: 'Descripción tarea.',
                    labelText:
                        'Ingresa una breve descripción de la tarea (max 100).',
                    controller: titleController),
              ),
              TextFormField(
                autocorrect: false,
                // maxLength: 100,
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 14),
                controller: descriptionController,
                decoration: _CustomInputDecoration(
                    hintText: 'Comentarios.',
                    labelText: 'Añade comentarios sobre la tarea.',
                    controller: descriptionController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Público',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Switch(
                      value: private,
                      onChanged: (newValue) => setState(
                        () {
                          private = newValue;
                        },
                      ),
                    ),
                    Text('Privado',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Lista:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        DropdownButton<String>(
                          value: stateDropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 20,
                          elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              stateDropdownValue = newValue!;
                            });
                          },
                          items: boardProvider.listCardState
                              .map((e) => e.name)
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Prioridad:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        DropdownButton<String>(
                          value: priorityDropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 20,
                          elevation: 16,
                          underline: Container(
                            height: 1,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              priorityDropdownValue = newValue!;
                            });
                          },
                          items: boardProvider.listPriorities
                              .map((e) => e.name)
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  //TODO: Falta incluir calendario para elegir la fecha de expiración
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                    height: 30,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.touch,
                        },
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          itemCount: kanbanColors.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 30,
                                height: 30,
                                color: kanbanColors[index],
                              ),
                            );
                          }),
                    )),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('Asignada a: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  //TODO: Falta tiene que poder elegirse
                  Text(widget.kanbanCard.userAsigned.name,
                      style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Text('Equipo asignado: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  (widget.kanbanCard.teamAsigned != null)
                      ? Row(children: [
                          //TODO: Falta tiene que poder elegirse
                          Text(widget.kanbanCard.teamAsigned!.name,
                              style: TextStyle(fontSize: 14)),
                        ])
                      : Text('ninguno', style: TextStyle(fontSize: 14))
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('Creador: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(widget.kanbanCard.creator.name,
                      style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Text('Fecha inicio: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  // Text(widget.kanbanCard.creationDate),

                  Text(
                      DateFormat('dd-MM-yyyy')
                          .format(widget.kanbanCard.creationDate),
                      style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _CustomInputDecoration(
      {required String hintText,
      required String labelText,
      required TextEditingController controller}) {
    return InputDecoration(
        hintText: hintText,
        suffixIcon: GestureDetector(
            child: const Icon(Icons.clear_rounded, color: Colors.grey),
            onTap: () {
              controller.text = '';
            }),
        labelText: labelText,
        hintStyle: TextStyle(fontSize: 10));
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('AlertDialog Title'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: <Widget>[
//             Text(kanbanCard.title),
//             Text('Would you like to approve of this message?'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Approve'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }
