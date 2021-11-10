import 'package:flutter/material.dart';
import 'package:simple_kanban/models/kanban_card.dart';

class KanbanCardWidget extends StatelessWidget {
  final KanbanCard kanbanCard;
  const KanbanCardWidget({Key? key, required this.kanbanCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: kanbanCard.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(4, 2), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          kanbanCard.cardColor.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
