class CardState {
  final String stateId;
  final String name;
  final String? description;
  final int position;

  CardState({
    required this.stateId,
    required this.name,
    this.description,
    required this.position,
  });
  

  CardState copyWith({
    String? stateId,
    String? name,
    String? description,
    int? position,
  }) {
    return CardState(
      stateId: stateId ?? this.stateId,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
    );
  }
}
