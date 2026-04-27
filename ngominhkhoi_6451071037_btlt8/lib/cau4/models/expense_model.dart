import 'category_model.dart';

class Expense {
  final int? id;
  final double amount;
  final String note;
  final int? categoryId;
  Category? category;

  Expense({
    this.id,
    required this.amount,
    required this.note,
    this.categoryId,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'categoryId': categoryId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      categoryId: map['categoryId'] as int?,
      category: map['category'] != null
          ? Category.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? note,
    int? categoryId,
    Category? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
    );
  }
}
