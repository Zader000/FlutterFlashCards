import 'package:flash_cards/models/deck_collection.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/deck.dart';
import '../models/flash_card.dart';

class DataAccess {
  late Database database;

  DataAccess();

  Future<void> init() async {
    database = await openDatabase(
        join(await getDatabasesPath(), 'flash_cards.db'),
        version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS deck_collection(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS deck(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          deckCollectionId INTEGER NOT NULL,
          FOREIGN KEY (deckCollectionId) REFERENCES deck_collection(id)
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS flash_card(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          question TEXT NOT NULL,
          answer TEXT NOT NULL,
          deckId INTEGER NOT NULL,
          FOREIGN KEY (deckId) REFERENCES deck(id)
        )
      ''');
    });
  }

  Future<void> insertDeckCollection(
      String collectionName, String collectionDescription) async {
    await init();
    await database.insert('deck_collection',
        {'name': collectionName, 'description': collectionDescription},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDeck(
      String name, String description, int collectionId) async {
    await init();
    await database.insert(
        'deck',
        {
          'name': name,
          'description': description,
          'deckCollectionId': collectionId
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertFlashCard(
      String question, String answer, int deckId) async {
    await init();
    await database.insert('flash_card',
        {'question': question, 'answer': answer, 'deckId': deckId},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DeckCollection>> getDeckCollections() async {
    await init();
    final List<Map<String, dynamic>> maps =
        await database.query('deck_collection');
    return List.generate(maps.length, (index) {
      return DeckCollection(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
      );
    });
  }

  Future<List<Deck>> getDecks(int deckCollectionId) async {
    await init();
    final List<Map<String, dynamic>> maps = await database.query('deck',
        where: 'deckCollectionId = ?', whereArgs: [deckCollectionId]);
    return List.generate(maps.length, (index) {
      return Deck(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
        deckCollectionId: maps[index]['deckCollectionId'],
      );
    });
  }

  Future<List<FlashCard>> getFlashCards(int deckId) async {
    await init();
    final List<Map<String, dynamic>> maps = await database
        .query('flash_card', where: 'deckId = ?', whereArgs: [deckId]);
    return List.generate(maps.length, (index) {
      return FlashCard(
        id: maps[index]['id'],
        question: maps[index]['question'],
        answer: maps[index]['answer'],
        deckId: maps[index]['deckId'],
      );
    });
  }

  Future<void> updateDeckCollection(DeckCollection deckCollection) async {
    await init();
    await database.update('deck_collection', deckCollection.toJson(),
        where: 'id = ?', whereArgs: [deckCollection.id]);
  }

  Future<void> updateDeck(Deck deck) async {
    await init();
    await database
        .update('deck', deck.toJson(), where: 'id = ?', whereArgs: [deck.id]);
  }

  Future<void> updateFlashCard(FlashCard flashCard) async {
    await init();
    await database.update('flash_card', flashCard.toJson(),
        where: 'id = ?', whereArgs: [flashCard.id]);
  }

  Future<void> deleteDeckCollection(int id) async {
    await init();
    await database.delete('deck_collection', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDeck(int id) async {
    await init();
    await database.delete('deck', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFlashCard(int id) async {
    await init();
    await database.delete('flash_card', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    await init();
    await database.delete('deck_collection');
    await database.delete('deck');
    await database.delete('flash_card');
  }

  Future<void> close() async {
    await init();
    await database.close();
  }

  Future<void> drop() async {
    await init();
    await database.execute('DROP TABLE deck_collection');
    await database.execute('DROP TABLE deck');
    await database.execute('DROP TABLE flash_card');
  }
}
