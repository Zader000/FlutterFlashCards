import 'package:flutter/material.dart';

import '../utils/data_access.dart';

class AddCardPage extends StatefulWidget {
  final int deckId;
  const AddCardPage({super.key, required this.deckId});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Card"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                da.insertFlashCard(
                  _questionController.text,
                  _answerController.text,
                  widget.deckId,
                );
                Navigator.pop(
                  context,
                  {
                    "front": _questionController.text,
                    "back": _answerController.text,
                  },
                );
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
