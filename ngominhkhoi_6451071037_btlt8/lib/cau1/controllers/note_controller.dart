import '../models/note_model.dart';
import '../utils/database_helper.dart';

class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Note>> getAllNotes() async {
    return await _dbHelper.readAllNotes();
  }

  Future<Note?> getNoteById(int id) async {
    return await _dbHelper.readNote(id);
  }

  Future<Note> createNote(String title, String content) async {
    final note = Note(title: title, content: content);
    return await _dbHelper.create(note);
  }

  Future<int> updateNote(Note note) async {
    return await _dbHelper.update(note);
  }

  Future<int> deleteNote(int id) async {
    return await _dbHelper.delete(id);
  }
}
