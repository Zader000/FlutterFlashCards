import "package:flash_cards/widgets/add_collection_page.dart";
import "package:flash_cards/widgets/collection_page.dart";
import "package:flutter/material.dart";
import "../models/deck_collection.dart";
import "../utils/data_access.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DeckCollection> _collections = [];

  Future<void> _loadCollections() async {
    var dataAccess = DataAccess();
    final List<DeckCollection> collections =
        await dataAccess.getDeckCollections();
    setState(() {
      _collections = collections;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _collections.isNotEmpty
          ? ListView.builder(
              itemCount: _collections.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_collections[index].name),
                  subtitle: Text(_collections[index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CollectionPage(collection: _collections[index])),
                    ).then((value) => _loadCollections());
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Collection"),
                          content: Text(
                              "Are you sure you want to delete ${_collections[index].name}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                var da = DataAccess();
                                da.deleteDeckCollection(
                                    _collections[index].id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Deleted ${_collections[index].name}"),
                                  ),
                                );
                                _loadCollections();
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text("No collections found"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCollectionPage()))
              .then((value) {
            if (value != null && value is Map) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added ${value['name']}"),
                ),
              );
              _loadCollections();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
