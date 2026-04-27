import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dictionary_entry_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isInitialized = false;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dictionary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dictionary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertEntry(DictionaryEntry entry) async {
    final db = await instance.database;
    await db.insert('dictionary', {
      'word': entry.word,
      'meaning': entry.meaning,
    });
  }

  Future<void> insertAll(List<DictionaryEntry> entries) async {
    final db = await instance.database;
    final batch = db.batch();
    for (final entry in entries) {
      batch.insert('dictionary', {
        'word': entry.word,
        'meaning': entry.meaning,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<DictionaryEntry>> search(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'dictionary',
      where: 'word LIKE ? OR meaning LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'word ASC',
    );
    return result.map((map) => DictionaryEntry.fromMap(map)).toList();
  }

  Future<List<DictionaryEntry>> getAllEntries() async {
    final db = await instance.database;
    final result = await db.query('dictionary', orderBy: 'word ASC');
    return result.map((map) => DictionaryEntry.fromMap(map)).toList();
  }

  Future<int> getCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM dictionary');
    return result.first['count'] as int;
  }

  Future<bool> isEmpty() async {
    final count = await getCount();
    return count == 0;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
