import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final Category? category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade300 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Không có danh mục',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          category!.name,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.deepPurple.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
