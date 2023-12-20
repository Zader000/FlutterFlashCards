class DeckCollection {
  final int id;
  final String name;
  final String description;

  DeckCollection(
      {required this.id, required this.name, required this.description});

  factory DeckCollection.fromJson(Map<String, dynamic> json) {
    return DeckCollection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  @override
  String toString() {
    return 'DeckCollection{id: $id, name: $name, description: $description}';
  }
}
