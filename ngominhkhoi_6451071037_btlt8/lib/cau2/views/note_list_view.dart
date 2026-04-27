import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../controllers/category_controller.dart';
import '../models/note_model.dart';
import '../models/category_model.dart';
import '../widgets/note_card.dart';
import '../../widgets/student_scaffold.dart';
import 'note_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final NoteController _noteController = NoteController();
  final CategoryController _categoryController = CategoryController();
  List<Note> _notes = [];
  List<Category> _categories = [];
  Category? _selectedCategory;
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
      final notes = _selectedCategory == null
          ? await _noteController.getAllNotes()
          : await _noteController.getNotesByCategory(_selectedCategory!.id!);
      setState(() {
        _categories = categories;
        _notes = notes;
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

  void _onCategorySelected(Category? category) {
    setState(() => _selectedCategory = category);
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final notes = _selectedCategory == null
          ? await _noteController.getAllNotes()
          : await _noteController.getNotesByCategory(_selectedCategory!.id!);
      setState(() {
        _notes = notes;
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

  Future<void> _deleteNote(Note note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có muốn xóa ghi chú "${note.title}" không?'),
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
      await _noteController.deleteNote(note.id!);
      _loadNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa ghi chú')),
        );
      }
    }
  }

  void _navigateToForm({Note? note}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormView(
          note: note,
          categories: _categories,
        ),
      ),
    );
    if (result == true) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Ghi chú có danh mục',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Thêm ghi chú',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Lọc theo danh mục: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Category?>(
                          value: _selectedCategory,
                          hint: const Text('Tất cả'),
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [
                            const DropdownMenuItem<Category?>(
                              value: null,
                              child: Text('Tất cả'),
                            ),
                            ..._categories.map((cat) => DropdownMenuItem<Category?>(
                              value: cat,
                              child: Text(cat.name),
                            )),
                          ],
                          onChanged: _onCategorySelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_outlined, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có ghi chú nào',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nhấn + để tạo ghi chú mới',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return NoteCard(
                              note: note,
                              onTap: () => _navigateToForm(note: note),
                              onDelete: () => _deleteNote(note),
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
