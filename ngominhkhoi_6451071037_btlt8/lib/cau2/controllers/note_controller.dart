import '../models/note_model.dart';
import '../utils/database_helper.dart';

class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Note>> getAllNotes() async {
    return await _dbHelper.getAllNotes();
  }

  Future<List<Note>> getNotesByCategory(int categoryId) async {
    return await _dbHelper.getNotesByCategory(categoryId);
  }

  Future<Note?> getNoteById(int id) async {
    return await _dbHelper.getNoteById(id);
  }

  Future<Note> createNote(String title, String content, int? categoryId) async {
    final note = Note(title: title, content: content, categoryId: categoryId);
    return await _dbHelper.createNote(note);
  }

  Future<int> updateNote(Note note) async {
    return await _dbHelper.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _dbHelper.deleteNote(id);
  }
}
