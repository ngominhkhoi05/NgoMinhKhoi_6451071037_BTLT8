import '../models/category_model.dart';
import '../utils/database_helper.dart';

class CategoryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Category>> getAllCategories() async {
    return await _dbHelper.getAllCategories();
  }

  Future<Category> createCategory(String name) async {
    final category = Category(name: name);
    return await _dbHelper.createCategory(category);
  }

  Future<int> updateCategory(Category category) async {
    return await _dbHelper.updateCategory(category);
  }

  Future<int> deleteCategory(int id) async {
    return await _dbHelper.deleteCategory(id);
  }
}
