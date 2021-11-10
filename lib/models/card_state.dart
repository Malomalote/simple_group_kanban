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
}
