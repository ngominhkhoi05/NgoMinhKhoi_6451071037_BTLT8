import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import '../controllers/category_controller.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../widgets/expense_card.dart';
import '../widgets/category_dropdown.dart';
import '../../widgets/student_scaffold.dart';

class ExpenseFormView extends StatefulWidget {
  final Expense? expense;
  final List<Category> categories;

  const ExpenseFormView({
    super.key,
    this.expense,
    required this.categories,
  });

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final ExpenseController _controller = ExpenseController();
  Category? _selectedCategory;
  bool _isLoading = false;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      if (widget.expense!.categoryId != null) {
        _selectedCategory = widget.categories.firstWhere(
          (cat) => cat.id == widget.expense!.categoryId,
          orElse: () => widget.categories.first,
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text.trim());
      final note = _noteController.text.trim();

      if (_isEditing) {
        final updatedExpense = widget.expense!.copyWith(
          amount: amount,
          note: note,
          categoryId: _selectedCategory?.id,
          category: _selectedCategory,
        );
        await _controller.updateExpense(updatedExpense);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật chi tiêu')),
          );
        }
      } else {
        await _controller.createExpense(amount, note, _selectedCategory?.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm chi tiêu')),
          );
        }
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: _isEditing ? 'Sửa chi tiêu' : 'Thêm chi tiêu',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  hintText: 'Nhập số tiền',
                  prefixText: 'đ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Số tiền phải lớn hơn 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Danh mục',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              CategoryDropdown(
                categories: widget.categories,
                selectedCategory: _selectedCategory,
                onChanged: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Nhập ghi chú',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập ghi chú';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isEditing ? 'Cập nhật' : 'Lưu',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
