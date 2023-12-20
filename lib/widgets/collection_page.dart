import 'package:flash_cards/models/deck_collection.dart';
import 'package:flash_cards/widgets/add_deck_page.dart';
import 'package:flash_cards/widgets/deck_page.dart';
import 'package:flash_cards/widgets/edit_collection_page.dart';
import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/data_access.dart';

class CollectionPage extends StatefulWidget {
  final DeckCollection collection;

  const CollectionPage({super.key, required this.collection});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Deck> _decks = [];
  late String barTitle;

  Future<void> _loadDecks() async {
    var da = DataAccess();
    final List<Deck> decks = await da.getDecks(widget.collection.id);
    setState(() {
      _decks = decks;
    });
  }

  @override
  void initState() {
    super.initState();
    barTitle = widget.collection.name;
    _loadDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(barTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditCollectionPage(collection: widget.collection)),
              ).then((value) {
                if (value != null && value is Map) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Updated ${value['name']}"),
                    ),
                  );
                  _loadDecks();
                  setState(() {
                    barTitle = value['name'];
                  });
                }
              });
            },
          ),
        ],
      ),
      body: _decks.isNotEmpty
          ? ListView.builder(
              itemCount: _decks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_decks[index].name),
                  subtitle: Text(_decks[index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeckPage(deck: _decks[index])),
                    ).then((value) => _loadDecks());
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Deck"),
                          content: Text(
                              "Are you sure you want to delete ${_decks[index].name}?"),
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
                                da.deleteDeck(_decks[index].id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Deleted ${_decks[index].name}"),
                                  ),
                                );
                                _loadDecks();
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
              child: Text("No decks yet"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddDeckPage(collectionId: widget.collection.id)),
          ).then((value) {
            if (value != null && value is Map) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added ${value['name']}"),
                ),
              );
              _loadDecks();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
