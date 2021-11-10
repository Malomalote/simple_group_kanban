import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:simple_kanban/db/card_state_queries.dart';
import 'package:simple_kanban/db/cards_queries.dart';
import 'package:simple_kanban/db/kanban_database.dart';
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
        child:

            // SingleChildScrollView(
            //   controller: controller,

            //   scrollDirection: Axis.horizontal,
            //   child: Row(children: [
            //     ...listCardState.map((e) => _Columna(cardState: e)).toList(),
            //   ]),
            ScrollConfiguration(
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
  @override
  Widget build(BuildContext context) {
    List<KanbanCard> cardsList =
        CardsQueries.getKanbanCardsFromStatus(widget.cardState.stateId, true);
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
                    //TODO: Falta mostrar una ficha con los datos de la categoría
                    print(widget.cardState.description);
                  },
                  icon: Icon(Icons.more_outlined, size: 15))
            ],
          ),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false, //para quitar icono de movimiento
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: <Widget>[
                for (int index = 0; index < cardsList.length; index++)
                  ReorderableDragStartListener(
                    index: index,
                    key: Key('$index'),
                    child: Container(
                      margin: EdgeInsets.all(4),
                      // padding: EdgeInsets.all(8),
                      child: KanbanCardWidget(kanbanCard: cardsList[index]),
                    ),
                  ),
                // ListTile(
                //   key: Key('$index'),
                //   tileColor: cardsList[index].isOdd ? oddItemColor : evenItemColor,
                //   title: Text('Item ${cardsList[index]}'),
                // ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final KanbanCard item = cardsList.removeAt(oldIndex);
                  cardsList.insert(newIndex, item);
                  //TODO: Falta esto hay que sacarlo de aquí no puede ir en el widget
                });
              },
            ),

            // child: ListView.builder(
            //     primary: false,
            //     shrinkWrap: true,
            //     // physics: NeverScrollableScrollPhysics(),
            //     itemCount: cardsList.length,
            //     itemBuilder: (_, index) {
            //       return Container(
            //         margin: EdgeInsets.all(8),
            //         child: KanbanCardWidget(kanbanCard: cardsList[index]),
            //       );
            //     }),
          ),
        ],
      ),
    );
  }
}
