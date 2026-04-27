import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/image_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('image_gallery.db');
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
      CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        name TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<ImageItem> insertImage(ImageItem image) async {
    final db = await instance.database;
    final id = await db.insert('images', image.toMap());
    return image.copyWith(id: id);
  }

  Future<List<ImageItem>> getAllImages() async {
    final db = await instance.database;
    final result = await db.query('images', orderBy: 'createdAt DESC');
    return result.map((map) => ImageItem.fromMap(map)).toList();
  }

  Future<int> deleteImage(int id) async {
    final db = await instance.database;
    return db.delete('images', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

class FileHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/gallery_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  static Future<Uint8List> _generateRandomImage({int width = 200, int height = 200}) async {
    final random = Random();
    final pixels = Uint8List(width * height * 4);

    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = random.nextInt(256);
      pixels[i + 1] = random.nextInt(256);
      pixels[i + 2] = random.nextInt(256);
      pixels[i + 3] = 255;
    }

    return pixels;
  }

  static Future<String> saveImage(Uint8List bytes, String filename) async {
    final path = await _localPath;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<void> deleteImageFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<Uint8List> generatePlaceholderImage() async {
    final random = Random();
    final width = 300;
    final height = 300;
    final pixels = Uint8List(width * height * 4);

    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);

    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = r;
      pixels[i + 1] = g;
      pixels[i + 2] = b;
      pixels[i + 3] = 255;
    }

    return pixels;
  }
}
