import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/card_state_provider.dart';

import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/views/widgets/custom_input_decoration.dart';

class StateCardDialog extends StatelessWidget {
  final CardState? cardState;
  const StateCardDialog({
    Key? key,
    this.cardState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      content: _StateForm(cardState: cardState),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {
            if (CardStateProvider.stateGlobalKey.currentState!.validate() &&
                CardStateProvider.nameState.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _ModifyDialog(cardState: cardState));
            } else {
              print('laskdjflañskdjfalsdjflaskdfa');
            }
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

class _StateForm extends StatefulWidget {
  final CardState? cardState;
  const _StateForm({
    Key? key,
    this.cardState,
  }) : super(key: key);

  @override
  State<_StateForm> createState() => _StateFormState();
}

class _StateFormState extends State<_StateForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cardState != null) {
      nameController.text = widget.cardState!.name;
      descriptionController.text = widget.cardState!.description ?? '';
      CardStateProvider.nameState=widget.cardState!.name;
      CardStateProvider.descriptionState=widget.cardState!.description ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    // final _stateFormKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: SizedBox(
        width: 600,
        child: Form(
          // key: _stateFormKey,
          key: CardStateProvider.stateGlobalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                maxLength: 100,
                maxLines: null,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Categoría.',
                    suffixIcon: GestureDetector(
                        child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.clear_rounded,
                                color: Colors.grey, size: 14)),
                        onTap: () {
                          nameController.text = '';
                          CardStateProvider.nameState = '';
                        }),
                    labelText:
                        'Ingresa una breve descripción de la categoría (max 100).',
                    hintStyle: const TextStyle(fontSize: 10)),
                onChanged: (value) {
                  CardStateProvider.nameState = value;
                },
                validator: (_) {
                  if (nameController.text.isEmpty ||
                      nameController.text.length > 100) {
                    return 'La descripción corta debe contener entre 1 y 100 caracteres';
                  }
                },
              ),
              TextFormField(
                autocorrect: false,
                // maxLength: 100,
                maxLines: null,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: 'Comentarios.',
                    suffixIcon: GestureDetector(
                        child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.clear_rounded,
                                color: Colors.grey, size: 14)),
                        onTap: () {
                          descriptionController.text = '';
                          CardStateProvider.descriptionState = '';
                        }),
                    labelText: 'Añade comentarios sobre la categoría.',
                    hintStyle: const TextStyle(fontSize: 10)),

                onChanged: (value) {
                  CardStateProvider.descriptionState = value;
                },
                // validator: (_) {
                //   if (descriptionController.text.isEmpty) {
                //     return 'Debe describir los hechos';
                //   }
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModifyDialog extends StatelessWidget {
  final CardState? cardState;
  const _ModifyDialog({Key? key, this.cardState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Modificar Categoría'),
      content: const Text('¿Se va a modificar la categoría seleccionada?'),
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
            if (cardState != null) {
              final newCardState = CardState(
                  stateId: cardState!.stateId,
                  name: CardStateProvider.nameState,
                  description: CardStateProvider.descriptionState,
                  position: cardState!.position);
              boardProvider.updateCardState(newCardState);
              Navigator.of(context)
                ..pop()
                ..pop();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
