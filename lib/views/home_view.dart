import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';

import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/utils/data_generator.dart';
import 'package:simple_kanban/views/widgets/kanban_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CardState> listCardState = CardStateQueries.getAllCardsState();
    ScrollController controller = ScrollController();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            child: ListView.builder(
                shrinkWrap: true,
                dragStartBehavior: DragStartBehavior.down,
                scrollDirection: Axis.horizontal,
                controller: controller,
                itemCount: listCardState.length,
                itemBuilder: (_, index) {
                  return _Columna(cardState: listCardState[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DataGenerator generator = DataGenerator();
          generator.tryColors();
          final username = Platform.environment['USERNAME'];
          print(username);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Columna extends StatefulWidget {
  CardState cardState;
  _Columna({
    Key? key,
    required this.cardState,
  }) : super(key: key);

  @override
  State<_Columna> createState() => _ColumnaState();
}

class _ColumnaState extends State<_Columna> {
  late List<KanbanCard> cardsList;
  @override
  void initState() {
    super.initState();
    cardsList =
        CardsQueries.getKanbanCardsFromStatus(widget.cardState.stateId, true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  widget.cardState.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    //TODO: show cardState CARD
                    print(widget.cardState.description);
                  },
                  icon: Icon(Icons.more_outlined, size: 15))
            ],
          ),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false, //remove reorderable icon
              primary: false,
              shrinkWrap: true,

              children: [
                ...cardsList
                    .map((item) => ReorderableDragStartListener(
                          key: Key('${item.cardId}'),
                          index: cardsList.indexOf(item),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: KanbanCardWidget(
                              kanbanCard: item,
                            ),
                          ),
                        ))
                    .toList(),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = cardsList.removeAt(oldIndex);
                  cardsList.insert(newIndex, item);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
