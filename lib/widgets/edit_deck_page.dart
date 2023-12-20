import 'package:flutter/material.dart';

import '../models/deck.dart';
import '../utils/data_access.dart';

class EditDeckPage extends StatefulWidget {
  final Deck deck;

  const EditDeckPage({super.key, required this.deck});

  @override
  State<EditDeckPage> createState() => _EditDeckPageState();
}

class _EditDeckPageState extends State<EditDeckPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.deck.name);
    _descriptionController =
        TextEditingController(text: widget.deck.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Deck"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var da = DataAccess();
                da.updateDeck(Deck(
                    id: widget.deck.id,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    deckCollectionId: widget.deck.deckCollectionId));
                Navigator.pop(
                  context,
                  {
                    "name": _nameController.text,
                    "description": _descriptionController.text,
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
