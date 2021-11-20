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
  final String private;
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
    required this.private,
    required this.cardColor,
    required this.position,
  });

  KanbanCard copyWith({
    String? cardId,
    User? creator,
    DateTime? creationDate,
    User? userAsigned,
    Team? teamAsigned,
    CardState? cardState,
    DateTime? stateDate,
    Priority? priority,
    String? title,
    String? description,
    DateTime? expirationDate,
    String? private,
    Color? cardColor,
    int? position,
  }) {
    return KanbanCard(
      cardId: cardId ?? this.cardId,
      creator: creator ?? this.creator,
      creationDate: creationDate ?? this.creationDate,
      userAsigned: userAsigned ?? this.userAsigned,
      teamAsigned: teamAsigned ?? this.teamAsigned,
      cardState: cardState ?? this.cardState,
      stateDate: stateDate ?? this.stateDate,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      expirationDate: expirationDate ?? this.expirationDate,
      private: private ?? this.private,
      cardColor: cardColor ?? this.cardColor,
      position: position ?? this.position,
    );
  }
}
