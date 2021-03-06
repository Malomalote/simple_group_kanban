

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:simple_kanban/views/widgets/dialogs/kanban_card_dialog.dart';
import 'package:simple_kanban/views/widgets/dialogs/state_card_dialog.dart';
import 'package:simple_kanban/views/widgets/kanban_card_widget.dart';
import 'package:simple_kanban/views/widgets/left_menu.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    boardProvider.initBoard();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: const _Body(),
      floatingActionButton: FloatingActionButton(
        //TODO: Falta cambiar este botón por uno de refresco 
        onPressed: () {
          Navigator.pop(context);
          // DataGenerator generator = DataGenerator();
          // generator.tryColors();
          // generator.fillKanbanDb();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: Row(
        children: [
          const LeftMenu(),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                 PointerDeviceKind.touch,
                },
              ),

              child: const _SingleColumn(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateColumn extends StatefulWidget {
  final CardState cardState;
  final int maxStates;
  const _StateColumn({
    Key? key,
    required this.cardState,
    required this.maxStates,
  }) : super(key: key);

  @override
  State<_StateColumn> createState() => _StateColumnState();
}

class _StateColumnState extends State<_StateColumn> {
  List<KanbanCard> cardsList = [];

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);

    setState(() {
      cardsList = boardProvider.listKanbanCard[widget.cardState.position];
    });

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                width: 250,
                child: Text(
                  widget.cardState.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            StateCardDialog(cardState: widget.cardState));
                  },
                  icon: const Icon(Icons.menu, size: 20)),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: [
                  ReorderableListView(
                    buildDefaultDragHandles: false, //remove reorderable icon
                    primary: false,
                    shrinkWrap: true,

                    children: [
                      ...cardsList.map((item) {
                        return ReorderableDragStartListener(
                          key: Key(item.cardId),
                          index: cardsList.indexOf(item),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: KanbanCardWidget(
                              kanbanCard: item,
                            ),
                          ),
                        );
                      }).toList(),
                    ],

                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = cardsList.removeAt(oldIndex);
                        cardsList.insert(newIndex, item);

                        for (var i = 0; i < cardsList.length; i++) {
                          boardProvider.updateCardPosition(cardsList[i], i);
                        }
                      });
                    },
                  ),
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Random rnd = Random();
                            boardProvider.backgroundKanbanColor = kanbanColors[0];
                                // kanbanColors[rnd.nextInt(kanbanColors.length)];
                            return KanbanCardDialog(
                              cardStateDefault: widget.cardState,
                              newCard: true,
                            );
                          },
                        );
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 35),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleColumn extends StatefulWidget {
  const _SingleColumn({Key? key}) : super(key: key);

  @override
  State<_SingleColumn> createState() => _SingleColumnState();
}

class _SingleColumnState extends State<_SingleColumn> {
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    List<CardState> listCardState = boardProvider.listCardState;
    return Row(
      children: [
        Expanded(
          child: ReorderableListView(
            buildDefaultDragHandles: false, //remove reorderable icon
            scrollDirection: Axis.horizontal,
             shrinkWrap: true,

            children: [
              ...listCardState.map((item) {
                return ReorderableDragStartListener(
                  //TODO: Falta activar solo para administrador
                  // enabled: false,
                  key: Key(item.stateId),
                  index: listCardState.indexOf(item),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: _StateColumn(
                      cardState: item,
                      maxStates: listCardState.length,
                    ),
                  ),
                );
              }).toList(),
            ],

            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = listCardState.removeAt(oldIndex);
                listCardState.insert(newIndex, item);

                for (var i = 0; i < listCardState.length; i++) {
                  boardProvider.updateStatePosition(listCardState[i], i);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
