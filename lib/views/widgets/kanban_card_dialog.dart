import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';

import 'package:simple_kanban/models/kanban_card.dart';

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
  TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.kanbanCard.title;
    commentsController.text = widget.kanbanCard.comments ?? '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final boardProvider=Provider.of<BoardProvider>(context,listen: false);
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
                controller: commentsController,
                decoration: _CustomInputDecoration(
                    hintText: 'Comentarios.',
                    labelText: 'Añade comentarios sobre la tarea.',
                    controller: commentsController),
              ),
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
