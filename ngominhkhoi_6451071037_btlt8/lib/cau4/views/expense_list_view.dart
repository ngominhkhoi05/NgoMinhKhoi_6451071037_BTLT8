import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import '../controllers/category_controller.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../widgets/expense_card.dart';
import '../../widgets/student_scaffold.dart';
import 'expense_form_view.dart';
import 'category_list_view.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final ExpenseController _expenseController = ExpenseController();
  final CategoryController _categoryController = CategoryController();
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  Map<int, double> _totalsByCategory = {};
  double _totalAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _categoryController.getAllCategories();
      final expenses = await _expenseController.getAllExpenses();
      final totals = await _expenseController.getTotalsByCategory();
      final total = await _expenseController.getTotalAmount();

      setState(() {
        _categories = categories;
        _expenses = expenses;
        _totalsByCategory = totals;
        _totalAmount = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} đ';
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có muốn xóa chi tiêu "${expense.note}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _expenseController.deleteExpense(expense.id!);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa chi tiêu')),
        );
      }
    }
  }

  void _navigateToForm({Expense? expense}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseFormView(
          expense: expense,
          categories: _categories,
        ),
      ),
    );
    if (result == true) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Quản lý chi tiêu',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Thêm chi tiêu',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.shade400,
                        Colors.red.shade600,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(_totalAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_totalsByCategory.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiêu theo danh mục',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((cat) {
                            final total = _totalsByCategory[cat.id] ?? 0;
                            if (total == 0) return const SizedBox.shrink();
                            return Chip(
                              avatar: const Icon(Icons.folder, size: 16),
                              label: Text('${cat.name}: ${_formatCurrency(total)}'),
                              backgroundColor: Colors.deepPurple.shade50,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _expenses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Chưa có chi tiêu nào',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nhấn + để thêm chi tiêu',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 80),
                            itemCount: _expenses.length,
                            itemBuilder: (context, index) {
                              final expense = _expenses[index];
                              return ExpenseCard(
                                expense: expense,
                                onTap: () => _navigateToForm(expense: expense),
                                onDelete: () => _deleteExpense(expense),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
