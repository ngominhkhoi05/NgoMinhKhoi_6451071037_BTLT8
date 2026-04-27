import '../models/dictionary_entry_model.dart';
import '../utils/database_helper.dart';
import '../utils/json_helper.dart';

class DictionaryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> initializeDatabase() async {
    final isEmpty = await _dbHelper.isEmpty();
    if (isEmpty) {
      final entries = await JsonHelper.loadFromAssets();
      await _dbHelper.insertAll(entries);
    }
  }

  Future<List<DictionaryEntry>> search(String query) async {
    if (query.trim().isEmpty) {
      return await _dbHelper.getAllEntries();
    }
    return await _dbHelper.search(query.trim());
  }

  Future<List<DictionaryEntry>> getAllEntries() async {
    return await _dbHelper.getAllEntries();
  }

  Future<int> getWordCount() async {
    return await _dbHelper.getCount();
  }
}
