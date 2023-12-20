import 'package:flash_cards/utils/data_access.dart';
import 'package:flutter/material.dart';

class AddDeckPage extends StatefulWidget {
  final int collectionId;

  const AddDeckPage({super.key, required this.collectionId});

  @override
  State<AddDeckPage> createState() => _AddDeckPageState();
}

class _AddDeckPageState extends State<AddDeckPage> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Deck"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var da = DataAccess();
                da.insertDeck(
                  nameController.text,
                  descriptionController.text,
                  widget.collectionId,
                );
                Navigator.pop(
                  context,
                  {
                    "name": nameController.text,
                    "description": descriptionController.text,
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
