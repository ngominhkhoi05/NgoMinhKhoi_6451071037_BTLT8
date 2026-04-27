import 'category_model.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final int? categoryId;
  Category? category;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categoryId': categoryId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      categoryId: map['categoryId'] as int?,
      category: map['category'] != null
          ? Category.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? categoryId,
    Category? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
    );
  }
}
