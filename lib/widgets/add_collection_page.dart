import 'package:flash_cards/utils/data_access.dart';
import 'package:flutter/material.dart';

class AddCollectionPage extends StatefulWidget {
  const AddCollectionPage({super.key});

  @override
  State<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Collection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                da.insertDeckCollection(
                  _nameController.text,
                  _descriptionController.text,
                );
                Navigator.pop(context, {
                  "name": _nameController.text,
                  "description": _descriptionController.text,
                });
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
