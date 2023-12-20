import 'package:flash_cards/utils/data_access.dart';
import 'package:flutter/material.dart';
import '../models/flash_card.dart';

class EditCardPage extends StatefulWidget {
  final FlashCard card;
  const EditCardPage({super.key, required this.card});

  @override
  State<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends State<EditCardPage> {
  final _answerController = TextEditingController();
  final _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _answerController.text = widget.card.answer;
    _questionController.text = widget.card.question;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Card"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: "Question",
              ),
            ),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var da = DataAccess();
                da.updateFlashCard(FlashCard(
                  id: widget.card.id,
                  question: _questionController.text,
                  answer: _answerController.text,
                  deckId: widget.card.deckId,
                ));
                Navigator.pop(
                  context,
                  {
                    "question": _questionController.text,
                    "answer": _answerController.text,
                  },
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
