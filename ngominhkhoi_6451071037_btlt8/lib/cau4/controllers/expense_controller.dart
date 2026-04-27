import '../models/expense_model.dart';
import '../utils/database_helper.dart';

class ExpenseController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Expense>> getAllExpenses() async {
    return await _dbHelper.getAllExpenses();
  }

  Future<Expense> createExpense(double amount, String note, int? categoryId) async {
    final expense = Expense(amount: amount, note: note, categoryId: categoryId);
    return await _dbHelper.createExpense(expense);
  }

  Future<int> updateExpense(Expense expense) async {
    return await _dbHelper.updateExpense(expense);
  }

  Future<int> deleteExpense(int id) async {
    return await _dbHelper.deleteExpense(id);
  }

  Future<Map<int, double>> getTotalsByCategory() async {
    return await _dbHelper.getTotalsByCategory();
  }

  Future<double> getTotalAmount() async {
    return await _dbHelper.getTotalAmount();
  }
}
