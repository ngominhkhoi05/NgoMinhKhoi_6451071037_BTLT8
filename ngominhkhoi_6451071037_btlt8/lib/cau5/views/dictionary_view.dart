import 'package:flutter/material.dart';
import '../controllers/dictionary_controller.dart';
import '../models/dictionary_entry_model.dart';
import '../widgets/word_tile.dart';
import '../../widgets/student_scaffold.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  final DictionaryController _controller = DictionaryController();
  final TextEditingController _searchController = TextEditingController();
  List<DictionaryEntry> _entries = [];
  bool _isLoading = true;
  bool _isSearching = false;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeAndLoad() async {
    setState(() => _isLoading = true);
    try {
      await _controller.initializeDatabase();
      final count = await _controller.getWordCount();
      final entries = await _controller.getAllEntries();
      setState(() {
        _wordCount = count;
        _entries = entries;
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

  Future<void> _search(String query) async {
    setState(() => _isSearching = true);
    try {
      final entries = await _controller.search(query);
      setState(() {
        _entries = entries;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tìm kiếm: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Từ điển offline',
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm từ...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _search('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _search(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.library_books, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '$_wordCount từ trong từ điển',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading || _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy từ nào',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 80),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          return WordTile(entry: _entries[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
