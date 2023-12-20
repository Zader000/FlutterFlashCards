class Deck {
  final int id;
  final String name;
  final String description;
  final int deckCollectionId;

  Deck({required this.id, required this.name, required this.description, required this.deckCollectionId});

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      deckCollectionId: json['deckCollectionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deckCollectionId': deckCollectionId,
    };
  }

  @override
  String toString() {
    return 'Deck{id: $id, name: $name, description: $description, deckCollectionId: $deckCollectionId}';
  }
}