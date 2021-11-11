import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_kanban/models/kanban_card.dart';

class KanbanCardWidget extends StatelessWidget {
  final KanbanCard kanbanCard;
  const KanbanCardWidget({Key? key, required this.kanbanCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //  height: 120,
      decoration: BoxDecoration(
        color: kanbanCard.cardColor,
        // color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(4, 2), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            _TopBar(kanbanCard: kanbanCard),
            SizedBox(height: 8),
            Text(kanbanCard.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(color: Colors.black)),
            _BottonBar(kanbanCard: kanbanCard)
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  final KanbanCard kanbanCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.arrow_back, size: 16),
        Container(
            alignment: Alignment.topLeft,
            width: 100,
            height: 5,
            color: kanbanCard.priority.priorityColor),
        Icon(Icons.arrow_forward, size: 16),
      ],
    );
  }
}

class _BottonBar extends StatelessWidget {
  final KanbanCard kanbanCard;
  _BottonBar({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool comments = false;

    if (kanbanCard.comments != null && kanbanCard.comments!.trim() != '') {
      comments = true;
    }
    String date = '';
    bool expirationDate = false;
    if (kanbanCard.expirationDate != null) {
      expirationDate = true;
      date = DateFormat('dd-MM-yyyy').format(kanbanCard.expirationDate!);
    }
    String team = '';
    bool teamAsigned = false;
    if (kanbanCard.teamAsigned != null) {
      teamAsigned = true;
      team = kanbanCard.teamAsigned!.name.substring(0, 2);
    }
    return (comments || expirationDate || teamAsigned)
        ? Column(
            children: [
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                if (date != '')
                  Row(children: [
                    Icon(Icons.timer, size: 14),
                    Text(date, style: TextStyle(fontSize: 12))
                  ]),
                if (comments) Icon(Icons.menu, size: 14),
                if (teamAsigned)
                  Container(
                    width: 15,
                    height: 15,
                    color: Colors.amberAccent,
                    child: Center(
                        child: Text(team, style: TextStyle(fontSize: 10))),
                  )
              ]),
            ],
          )
        : Container();
  }
}
