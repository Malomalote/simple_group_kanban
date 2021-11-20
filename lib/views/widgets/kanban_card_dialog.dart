import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/kanban_card_provider.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:simple_kanban/views/widgets/custom_input_decoration.dart';
import 'package:simple_kanban/views/widgets/kanban_card_widget.dart';

class KanbanCardDialog extends StatelessWidget {
  final KanbanCard? kanbanCard;
  final CardState? cardStateDefault;
  final bool newCard;
  const KanbanCardDialog({
    Key? key,
    this.kanbanCard,
    this.cardStateDefault,
    required this.newCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    KanbanCardProvider.isNewKanbanCard=newCard;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(1),
      backgroundColor: boardProvider.backgroundKanbanColor,
      content: _KanbanForm(kanbanCard: kanbanCard, cardState: cardStateDefault),
      actions: <Widget>[
        Row(
          children: [
            if (kanbanCard != null)
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _DeleteKanbanCardDialog(kanbanCard: kanbanCard));
                },
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    Text(
                      'Eliminar Tarea',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                if (KanbanCardProvider.kanbanCardGlobalKey.currentState!
                        .validate() &&
                    KanbanCardProvider.title != null &&
                    KanbanCardProvider.title!.trim().isNotEmpty &&
                    KanbanCardProvider.cardState != null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _ModifyKanbanCardDialog());
                }
              },
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

class _KanbanForm extends StatefulWidget {
  final KanbanCard? kanbanCard;
  final CardState? cardState;
  const _KanbanForm({
    Key? key,
    this.kanbanCard,
    this.cardState,
  }) : super(key: key);

  @override
  State<_KanbanForm> createState() => _KanbanFormState();
}

class _KanbanFormState extends State<_KanbanForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String stateDropdownValue = '';
  String priorityDropdownValue = '';
  String asignedUser = '';
  String? asignedTeam;
  bool private = true;
  bool newTask = true;
  DateTime? selectedDate;

  CardState? cardState;
  @override
  void initState() {
    super.initState();
    if (!KanbanCardProvider.isNewKanbanCard) {
      KanbanCardProvider.initProvider(widget.kanbanCard!);
      titleController.text = widget.kanbanCard!.title;
      descriptionController.text = widget.kanbanCard!.description ?? '';
      stateDropdownValue = widget.kanbanCard!.cardState.name;
      priorityDropdownValue = widget.kanbanCard!.priority.name;
      newTask = false;
      if (widget.kanbanCard!.private == 'false') private = false;
      if (widget.kanbanCard!.private == 'true') private = true;
      asignedUser = widget.kanbanCard!.userAsigned.name;
      if (widget.kanbanCard!.teamAsigned != null) {
        asignedTeam = widget.kanbanCard!.teamAsigned!.name;
      }
      if (widget.kanbanCard!.expirationDate != null) {
        selectedDate = widget.kanbanCard!.expirationDate;
      }
    } else {
      stateDropdownValue = widget.cardState!.name;
      KanbanCardProvider.private = private.toString();
      KanbanCardProvider.cardState=cardState;
      Random rnd = Random();
      KanbanCardProvider.cardColor= kanbanColors[rnd.nextInt(kanbanColors.length)];
    }
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

    // final _cardFormKey = GlobalKey<FormState>();
    if (widget.kanbanCard == null) {
      asignedUser = boardProvider.currentUser!.name;
      KanbanCardProvider.userAsigned = boardProvider.currentUser;
      KanbanCardProvider.creator = boardProvider.currentUser;
      KanbanCardProvider.priority = boardProvider.getDefaultPriority();
      KanbanCardProvider.creationDate = DateTime.now();
    }

    List<DropdownMenuItem<String>> buildStateDropdown() {
      List<DropdownMenuItem<String>> toReturn = [];
      toReturn.addAll(boardProvider.listCardState
          .map((e) => e.name)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList());

      return toReturn;
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: 600,
        child: Form(
          key: KanbanCardProvider.kanbanCardGlobalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                maxLength: 100,
                maxLines: null,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: titleController,
                decoration: CustomInputDecoration(
                    hintText: 'Descripción tarea.',
                    labelText:
                        'Ingresa una breve descripción de la tarea (max 100).',
                    controller: titleController,
                    onTap: (){
                      titleController.text='';
                      KanbanCardProvider.title='';
                    },
                    
                    ),
                onChanged: (value) {
                  KanbanCardProvider.title = value;
                },
                validator: (_) {
                  if (titleController.text.isEmpty ||
                      titleController.text.length > 100) {
                    return 'La descripción corta debe contener entre 1 y 100 caracteres';
                  }
                },
              ),
              TextFormField(
                autocorrect: false,
                maxLines: null,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: descriptionController,
                decoration: CustomInputDecoration(
                    hintText: 'Comentarios.',
                    labelText: 'Añade comentarios sobre la tarea.',
                    controller: descriptionController,
                                        onTap: (){
                      descriptionController.text='';
                      KanbanCardProvider.description='';
                    },),
                onChanged: (value) {
                  KanbanCardProvider.description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Público',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Switch(
                      value: private,
                      onChanged: (newValue) => setState(
                        () {
                          private = newValue;
                          KanbanCardProvider.private = newValue.toString();
                        },
                      ),
                    ),
                    const Text('Privado',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Categoría:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        DropdownButton<String>(
                          value: (stateDropdownValue == '')
                              ? null
                              : stateDropdownValue,
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
                              KanbanCardProvider.cardState =
                                  boardProvider.getCardStateFromName(newValue);
                              KanbanCardProvider.stateDate = DateTime.now();
                            });
                          },
                          items: buildStateDropdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Prioridad:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 20),
                    DropdownButton<String>(
                      value: (priorityDropdownValue == '')
                          ? boardProvider.getDefaultPriority()?.name
                          : priorityDropdownValue,
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
                          KanbanCardProvider.priority =
                              boardProvider.getPriorityFromName(newValue);
                        });
                      },
                      items: boardProvider.listPriorities
                          .map((e) => e)
                          .map<DropdownMenuItem<String>>((Priority value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Container(
                              color: value.priorityColor.withAlpha(300),
                              child: Text(value.name)),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        // (widget.kanbanCard != null &&
                        //         widget.kanbanCard!.expirationDate != null)
                        (selectedDate != null)
                            ? InkWell(
                                onTap: () => _selectDate(context),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Fecha límite: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(DateFormat('dd-MM-yyyy')
                                        .format(selectedDate!)),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () => _selectDate(context),
                                child: const Text('Seleccionar fecha límite',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
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
                              child: GestureDetector(
                                onTap: () {
                                  boardProvider.backgroundKanbanColor =
                                      kanbanColors[index];
                                  KanbanCardProvider.cardColor =
                                      kanbanColors[index];
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      color: kanbanColors[index],
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                ),
                              ),
                            );
                          }),
                    )),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text('Asignada a: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  //TODO: Falta tiene que poder elegirse
                  DropdownButton<String>(
                    value: (asignedUser == '')
                        ? boardProvider.currentUser!.name
                        : asignedUser,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        asignedUser = newValue!;
                        KanbanCardProvider.userAsigned =
                            boardProvider.getUserFromName(newValue);
                      });
                    },
                    items: boardProvider.listUsers
                        .map((e) => e.name)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  // Text(
                  //   (widget.kanbanCard == null) ? boardProvider.currentUser!.name :
                  //   widget.kanbanCard!.userAsigned.name,
                  //     style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Text('Equipo asignado: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

                  DropdownButton<String>(
                    value: (asignedTeam !=
                            null) //TODO: Falta igual se puede quitar esto
                        ? asignedTeam
                        : null,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        asignedTeam = newValue!;
                        KanbanCardProvider.teamAsigned =
                            boardProvider.getTeamFromName(newValue);
                      });
                    },
                    items: [
                      const DropdownMenuItem(value: '', child: Text('')),
                      ...boardProvider.listTeams
                          .map((e) => e.name)
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text('Creador: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(
                      (widget.kanbanCard != null)
                          ? widget.kanbanCard!.creator.name
                          : boardProvider.currentUser!.name,
                      style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Text('Fecha inicio: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  // Text(widget.kanbanCard.creationDate),

                  Text(
                      DateFormat('dd-MM-yyyy').format(
                          (widget.kanbanCard != null)
                              ? widget.kanbanCard!.creationDate
                              : DateTime.now()),
                      style: const TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    selectedDate ??= DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        KanbanCardProvider.expirationDate = selected;
      });
    }
  }
}

class _DeleteKanbanCardDialog extends StatelessWidget {
  final KanbanCard? kanbanCard;
  const _DeleteKanbanCardDialog({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return AlertDialog(
      title: Text('Elimiar Tarea: ${kanbanCard!.title}'),
      content: Text('¿Se va a borrar la Tarea ${kanbanCard!.title}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          child: const Text('OK',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          onPressed: () {
            boardProvider.deleteKanbanCard(kanbanCard!);

            Navigator.of(context)
              ..pop()
              ..pop();
          },
        ),
      ],
    );
  }
}

class _ModifyKanbanCardDialog extends StatelessWidget {
  const _ModifyKanbanCardDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return AlertDialog(
      title: (KanbanCardProvider.isNewKanbanCard)
          ? const Text('Añadir tarea')
          : const Text('Modificar tarea'),
      content: (KanbanCardProvider.isNewKanbanCard)
          ? Text('¿Añadir tarea: ${KanbanCardProvider.title}')
          : Text('¿Modificar la tarea: ${KanbanCardProvider.title}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          child: const Text('OK',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          onPressed: () {
            KanbanCardProvider.position = boardProvider
                .getKanbanCardsFromStatus(KanbanCardProvider.cardState!, false)
                .length;

            (KanbanCardProvider.isNewKanbanCard)
                ? boardProvider
                    .addKanbanCard(KanbanCardProvider.getKanbanCard())
                : boardProvider
                    .updateKanbanCard(KanbanCardProvider.getKanbanCard());

            KanbanCardProvider.isNewKanbanCard = true;
            Navigator.of(context)
              ..pop()
              ..pop();
          },
        ),
      ],
    );
  }
}
