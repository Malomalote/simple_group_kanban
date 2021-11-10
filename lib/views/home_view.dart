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

class _Columna extends StatelessWidget {
  CardState cardState;
  _Columna({
    Key? key,
    required this.cardState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<KanbanCard> cardsList =
        CardsQueries.getKanbanCardsFromStatus(cardState.stateId, true);
    return Container(
      width: 300,
      child: ListView.builder(
          primary: false,
          // scrollDirection: Axis.vertical,
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: cardsList.length,
          itemBuilder: (_, index) {
            return Container(
              // padding: const EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8),
              child: KanbanCardWidget(kanbanCard: cardsList[index]),
            );
            //  ListTile(
            //   title: Text(cardsList[index].cardId),
            // );
          }),
    );
  }
}
