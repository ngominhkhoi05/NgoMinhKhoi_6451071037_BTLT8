import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dictionary_entry_model.dart';

class JsonHelper {
  static Future<List<DictionaryEntry>> loadFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/cau5/dictionary_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((json) => DictionaryEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
