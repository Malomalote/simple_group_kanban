import 'package:flutter/material.dart';

import 'package:simple_kanban/models/card_state.dart';
import 'package:simple_kanban/models/priority.dart';
import 'package:simple_kanban/models/team.dart';
import 'package:simple_kanban/models/user.dart';

class KanbanCard {
  final String cardId;
  final User creator;
  final DateTime creationDate;
  final User userAsigned;
  Team? teamAsigned;
  final CardState cardState;
  final DateTime stateDate;
  final Priority priority;
  final String title;
  final String? description;
  DateTime? expirationDate;
  final String? comments;
  final Color cardColor;
  final int position;
  KanbanCard({
    required this.cardId,
    required this.creator,
    required this.creationDate,
    required this.userAsigned,
    this.teamAsigned,
    required this.cardState,
    required this.stateDate,
    required this.priority,
    required this.title,
    this.description,
    this.expirationDate,
    this.comments,
    required this.cardColor,
    required this.position,
  });
}
