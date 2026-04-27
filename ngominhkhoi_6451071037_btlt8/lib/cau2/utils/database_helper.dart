import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_with_category.db');
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
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');
  }

  // ==================== CATEGORY OPERATIONS ====================

  Future<Category> createCategory(Category category) async {
    final db = await instance.database;
    final id = await db.insert('categories', {'name': category.name});
    return category.copyWith(id: id);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> updateCategory(Category category) async {
    final db = await instance.database;
    return db.update(
      'categories',
      {'name': category.name},
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== NOTE OPERATIONS ====================

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', {
      'title': note.title,
      'content': note.content,
      'categoryId': note.categoryId,
    });
    return note.copyWith(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT notes.*, categories.name as categoryName, categories.id as catId
      FROM notes
      LEFT JOIN categories ON notes.categoryId = categories.id
      ORDER BY notes.id DESC
    ''');

    return result.map((map) {
      Category? category;
      if (map['categoryId'] != null && map['categoryName'] != null) {
        category = Category(
          id: map['catId'] as int?,
          name: map['categoryName'] as String,
        );
      }
      return Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        categoryId: map['categoryId'] as int?,
        category: category,
      );
    }).toList();
  }

  Future<List<Note>> getNotesByCategory(int categoryId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT notes.*, categories.name as categoryName, categories.id as catId
      FROM notes
      LEFT JOIN categories ON notes.categoryId = categories.id
      WHERE notes.categoryId = ?
      ORDER BY notes.id DESC
    ''', [categoryId]);

    return result.map((map) {
      Category? category;
      if (map['categoryId'] != null && map['categoryName'] != null) {
        category = Category(
          id: map['catId'] as int?,
          name: map['categoryName'] as String,
        );
      }
      return Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        categoryId: map['categoryId'] as int?,
        category: category,
      );
    }).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT notes.*, categories.name as categoryName, categories.id as catId
      FROM notes
      LEFT JOIN categories ON notes.categoryId = categories.id
      WHERE notes.id = ?
    ''', [id]);

    if (result.isNotEmpty) {
      final map = result.first;
      Category? category;
      if (map['categoryId'] != null && map['categoryName'] != null) {
        category = Category(
          id: map['catId'] as int?,
          name: map['categoryName'] as String,
        );
      }
      return Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        categoryId: map['categoryId'] as int?,
        category: category,
      );
    }
    return null;
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      {
        'title': note.title,
        'content': note.content,
        'categoryId': note.categoryId,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
