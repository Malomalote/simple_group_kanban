import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/views/widgets/kanban_card_dialog.dart';

class KanbanCardWidget extends StatelessWidget {
  final KanbanCard kanbanCard;
  const KanbanCardWidget({Key? key, required this.kanbanCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                KanbanCardDialog(kanbanCard: kanbanCard));
      },
      child: Container(
        width: double.infinity,
        //  height: 120,
        decoration: BoxDecoration(
          color: kanbanCard.cardColor,
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(4, 2), blurRadius: 4),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            children: [
              _TopBar(kanbanCard: kanbanCard),
              const SizedBox(height: 8),
              Text(kanbanCard.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black)),
              _BottonBar(kanbanCard: kanbanCard)
            ],
          ),
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
        const Icon(Icons.arrow_back, size: 16),
        Container(
            alignment: Alignment.topLeft,
            width: 100,
            height: 5,
            color: kanbanCard.priority.priorityColor),
        const Icon(Icons.arrow_forward, size: 16),
      ],
    );
  }
}

class _BottonBar extends StatelessWidget {
  final KanbanCard kanbanCard;
  const _BottonBar({
    Key? key,
    required this.kanbanCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool description = false;

    if (kanbanCard.description != null &&
        kanbanCard.description!.trim() != '') {
      description = true;
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
    return (description || expirationDate || teamAsigned)
        ? Column(
            children: [
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                if (date != '')
                  Row(children: [
                    const Icon(Icons.timer, size: 14),
                    Text(date, style: const TextStyle(fontSize: 12))
                  ]),
                if (description) const Icon(Icons.menu, size: 14),
                if (teamAsigned)
                  Container(
                    width: 15,
                    height: 15,
                    color: Colors.indigoAccent,
                    child: Center(
                        child: Text(team,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white))),
                  )
              ]),
            ],
          )
        : Container();
  }
}
