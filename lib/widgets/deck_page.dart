import 'package:flash_cards/widgets/edit_card_page.dart';
import 'package:flash_cards/widgets/edit_deck_page.dart';
import 'package:flash_cards/widgets/study_page.dart';
import 'package:flutter/material.dart';

import '../models/deck.dart';
import '../models/flash_card.dart';
import '../utils/data_access.dart';
import 'add_card_page.dart';

class DeckPage extends StatefulWidget {
  final Deck deck;

  const DeckPage({super.key, required this.deck});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  List<FlashCard> _cards = [];
  late String barTitle;

  Future<void> _loadCards() async {
    var da = DataAccess();
    final List<FlashCard> cards = await da.getFlashCards(widget.deck.id);
    setState(() {
      _cards = cards;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
    barTitle = widget.deck.name;
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
                  builder: (context) => EditDeckPage(deck: widget.deck),
                ),
              ).then((value) {
                if (value != null && value is Map) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Updated ${value['name']}"),
                    ),
                  );
                  _loadCards();
                  setState(() {
                    barTitle = value['name'];
                  });
                }
              });
            },
          ),
        ],
      ),
      body: _cards.isNotEmpty
          ? Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudyPage(cards: _cards),
                          )).then((value) => {});
                    },
                    child: const Text("Start Quiz")),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_cards[index].question),
                        subtitle: Text(_cards[index].answer),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCardPage(card: _cards[index])
                            )
                          ).then((value) => _loadCards());
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Card"),
                                content: Text(
                                    "Are you sure you want to delete ${_cards[index].question}?"),
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
                                      da.deleteFlashCard(_cards[index].id);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Deleted ${_cards[index].question}"),
                                        ),
                                      );
                                      _loadCards();
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text("No cards yet"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCardPage(
                deckId: widget.deck.id,
              ),
            ),
          ).then((value) {
            if (value != null && value is Map) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Added Card",
                  ),
                ),
              );
              _loadCards();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
