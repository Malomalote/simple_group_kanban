import 'package:flutter/material.dart';
import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/kanban_card.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';
import 'package:simple_kanban/utils/utils.dart';

class KanbanCardProvider {
  static GlobalKey<FormState> kanbanCardGlobalKey = GlobalKey<FormState>();

  static String? title;
  static User? creator;
  static String? cardId;

  static DateTime? creationDate;
  static User? userAsigned;
  static Team? teamAsigned;
  static CardState? cardState;
  static DateTime? stateDate;
  static Priority? priority;
  static String? description;
  static DateTime? expirationDate;
  static String? private;
  static Color? cardColor;
  static int? position;
  static bool isNewKanbanCard = true;

  static void initProvider(KanbanCard kanbanCard) {
    cardId = kanbanCard.cardId;
    creator = kanbanCard.creator;
    creationDate = kanbanCard.creationDate;
    userAsigned = kanbanCard.userAsigned;
    teamAsigned = kanbanCard.teamAsigned;
    cardState = kanbanCard.cardState;
    stateDate = kanbanCard.stateDate;
    priority = kanbanCard.priority;
    title = kanbanCard.title;
    description = kanbanCard.description;
    expirationDate = kanbanCard.expirationDate;
    private = kanbanCard.private;
    cardColor = kanbanCard.cardColor;
    position = kanbanCard.position;
    isNewKanbanCard = false;
  }
  static KanbanCard getKanbanCard(){
    
    final newId = cardId ?? Utils.newNuid();
    KanbanCard kanbanCard = KanbanCard(cardId: newId, creator: creator!, creationDate: creationDate!, userAsigned: userAsigned!, cardState: cardState!, stateDate: stateDate!, priority: priority!, title: title!, description: description!, private: private!, cardColor: cardColor!, position: position!);
    return kanbanCard;
  }
}
