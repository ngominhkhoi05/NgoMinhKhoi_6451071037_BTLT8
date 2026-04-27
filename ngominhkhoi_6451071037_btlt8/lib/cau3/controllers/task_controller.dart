import '../models/task_model.dart';
import '../utils/database_helper.dart';
import '../utils/file_helper.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Task>> getAllTasks() async {
    return await _dbHelper.getAllTasks();
  }

  Future<Task> createTask(String title) async {
    final task = Task(title: title);
    return await _dbHelper.createTask(task);
  }

  Future<int> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    return await _dbHelper.updateTask(updatedTask);
  }

  Future<int> updateTask(Task task) async {
    return await _dbHelper.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _dbHelper.deleteTask(id);
  }

  Future<void> exportTasks(List<Task> tasks) async {
    await FileHelper.exportToJson(tasks);
  }

  Future<List<Task>> importTasks() async {
    return await FileHelper.importFromJson();
  }

  Future<void> replaceAllTasks(List<Task> tasks) async {
    await _dbHelper.deleteAllTasks();
    await _dbHelper.insertAllTasks(tasks);
  }
}
