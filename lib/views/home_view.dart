import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/utils/data_generator.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:simple_kanban/views/widgets/kanban_card_dialog.dart';
import 'package:simple_kanban/views/widgets/kanban_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    boardProvider.initBoard();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _Body(),
      floatingActionButton: FloatingActionButton(
        //TODO: Falta borrar este botón
        onPressed: () {
          DataGenerator generator = DataGenerator();
          generator.tryColors();
          generator.fillKanbanDb();
          final username = Platform.environment['USERNAME'];
          print(username);
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
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    //List<CardState> listCardState = boardProvider.listCardState();
    List<CardState> listCardState = boardProvider.listCardState;
    ScrollController controller = ScrollController();
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: [
              ...listCardState
                  .map((e) => _Columna(
                        cardState: e,
                        maxStates: listCardState.length,
                      ))
                  .toList(),
              Column(
                children: [
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      child: Text(
                        'Añadir nueva lista',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              )
            ],
          )),
    );
  }
}

class _Columna extends StatefulWidget {
  CardState cardState;
  int maxStates;
  _Columna({Key? key, required this.cardState, required this.maxStates})
      : super(key: key);

  @override
  State<_Columna> createState() => _ColumnaState();
}

class _ColumnaState extends State<_Columna> {
  List<KanbanCard> cardsList = [];

  @override
  Widget build(BuildContext context) {
    print('aqui');
    final boardProvider = Provider.of<BoardProvider>(context);

    setState(() {
      cardsList = boardProvider.listKanbanCard[widget.cardState.position];
    });

    return (cardsList.isEmpty)
        ? CircularProgressIndicator()
        : Container(
            width: 300,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 16),
                    if (widget.cardState.position != 0)
                      // MouseRegion(
                      //   cursor: SystemMouseCursors.move,
                      // child:
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 16),
                        onPressed: () {
                          boardProvider.moveState(
                              cardState: widget.cardState,
                              direction: CardDirection.izquierda);
                          cardsList = boardProvider
                              .listKanbanCard[widget.cardState.position];

                          setState(() {});
                        },
                      ),
                    Spacer(),
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        widget.cardState.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          //TODO: show cardState CARD
                          print(widget.cardState.description);
                        },
                        icon: Icon(Icons.more_outlined, size: 15)),
                    if (widget.cardState.position != widget.maxStates - 1)
                      IconButton(
                        icon: Icon(Icons.arrow_forward, size: 16),
                        onPressed: () {
                          boardProvider.moveState(
                              cardState: widget.cardState,
                              direction: CardDirection.derecha);
                          cardsList = boardProvider
                              .listKanbanCard[widget.cardState.position];

                          setState(() {});
                        },
                      ),
                    SizedBox(width: 16),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      children: [
                        ReorderableListView(
                          buildDefaultDragHandles:
                              false, //remove reorderable icon
                          primary: false,
                          shrinkWrap: true,

                          children: [
                            ...cardsList.map((item) {
                              return ReorderableDragStartListener(
                                key: Key('${item.cardId}'),
                                index: cardsList.indexOf(item),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
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
                                boardProvider.updateCardPosition(
                                    cardsList[i], i);
                              }
                            });
                          },
                        ),
                        InkWell(
                            onTap: () {
                                 showDialog(
            context: context,
            builder: (BuildContext context) =>
                KanbanCardDialog(cardStateDefault: widget.cardState,));
                       
                            },
                            child: Text(
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
