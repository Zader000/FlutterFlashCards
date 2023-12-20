class FlashCard {
  final int id;
  final String question;
  final String answer;
  final int deckId;

  FlashCard({required this.id, required this.question,
    required this.answer, required this.deckId});

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      deckId: json['deckId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'deckId': deckId,
    };
  }

  @override
  String toString() {
    return 'FlashCard{id: $id, question: $question, answer: $answer, deckId: $deckId}';
  }
}