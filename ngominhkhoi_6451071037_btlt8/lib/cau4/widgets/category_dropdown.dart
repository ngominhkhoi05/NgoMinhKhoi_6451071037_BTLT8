import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?> onChanged;
  final String? hintText;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<Category?>(
        value: selectedCategory,
        hint: Text(hintText ?? 'Chọn danh mục'),
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          const DropdownMenuItem<Category?>(
            value: null,
            child: Text('Không có danh mục'),
          ),
          ...categories.map((cat) => DropdownMenuItem<Category?>(
            value: cat,
            child: Text(cat.name),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
