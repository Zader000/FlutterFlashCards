import 'package:flutter/material.dart';

import '../models/flash_card.dart';

class StudyPage extends StatefulWidget {
  final List<FlashCard> cards;
  const StudyPage({super.key, required this.cards});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _index = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "${_index + 1} of ${widget.cards.length}",
              style: const TextStyle(fontSize: 20),
            ),
            Expanded(
              child: Center(
                child: _showAnswer
                    ? Text(
                        widget.cards[_index].answer,
                        style: const TextStyle(fontSize: 30),
                      )
                    : Text(
                        widget.cards[_index].question,
                        style: const TextStyle(fontSize: 30),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAnswer = !_showAnswer;
                    });
                  },
                  child: Text(_showAnswer ? "Question" : "Answer"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _index = (_index + 1) % widget.cards.length;
                      _showAnswer = false;
                    });
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
