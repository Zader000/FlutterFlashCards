import 'package:flutter/material.dart';

import '../models/deck_collection.dart';
import '../utils/data_access.dart';

class EditCollectionPage extends StatefulWidget {
  final DeckCollection collection;
  const EditCollectionPage({super.key, required this.collection});

  @override
  State<EditCollectionPage> createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.collection.name);
    _descriptionController = TextEditingController(text: widget.collection.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Collection"),
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
                da.updateDeckCollection(DeckCollection(
                  id: widget.collection.id,
                  name: _nameController.text,
                  description: _descriptionController.text,
                ));
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
