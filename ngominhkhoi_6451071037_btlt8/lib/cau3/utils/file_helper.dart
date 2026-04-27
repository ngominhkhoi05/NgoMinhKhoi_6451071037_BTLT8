import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class FileHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks_backup.json');
  }

  static Future<void> exportToJson(List<Task> tasks) async {
    final file = await _localFile;
    final jsonData = tasks.map((task) => task.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert({
      'exportDate': DateTime.now().toIso8601String(),
      'tasks': jsonData,
    });
    await file.writeAsString(jsonString);
  }

  static Future<List<Task>> importFromJson() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        throw Exception('File not found');
      }
      final contents = await file.readAsString();
      final Map<String, dynamic> data = json.decode(contents);
      final List<dynamic> tasksJson = data['tasks'] as List<dynamic>;
      return tasksJson
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> backupFileExists() async {
    final file = await _localFile;
    return await file.exists();
  }

  static Future<String?> getBackupFilePath() async {
    final file = await _localFile;
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }
}
