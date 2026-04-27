import 'package:flutter/material.dart';
import '../cau1/apps/cau1_app.dart';
import '../cau2/apps/cau2_app.dart';
import '../cau3/apps/cau3_app.dart';
import '../cau4/apps/cau4_app.dart';
import '../cau5/apps/cau5_app.dart';
import '../cau6/apps/cau6_app.dart';
import '../cau7/apps/cau7_app.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = List.generate(7, (index) {
      return _MenuItem(
        number: index + 1,
        label: 'Câu ${index + 1}',
        icon: Icons.article_outlined,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('BTLT - Ngô Minh Khôi'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'CHỌN CÂU',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bài tập lớn - Flutter',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple.shade600,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return _MenuCard(item: item);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text(
          '6451071037 - Ngô Minh Khôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final int number;
  final String label;
  final IconData icon;

  const _MenuItem({
    required this.number,
    required this.label,
    required this.icon,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _getScreen(item.number),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 40,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getScreen(int number) {
    switch (number) {
      case 1:
        return const Cau1App();
      case 2:
        return const Cau2App();
      case 3:
        return const Cau3App();
      case 4:
        return const Cau4App();
      case 5:
        return const Cau5App();
      case 6:
        return const Cau6App();
      case 7:
        return const Cau7App();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _Cau1Placeholder extends StatelessWidget {
  const _Cau1Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 1')),
      body: const Center(child: Text('Nội dung Câu 1')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau2Placeholder extends StatelessWidget {
  const _Cau2Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 2')),
      body: const Center(child: Text('Nội dung Câu 2')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau3Placeholder extends StatelessWidget {
  const _Cau3Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 3')),
      body: const Center(child: Text('Nội dung Câu 3')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau4Placeholder extends StatelessWidget {
  const _Cau4Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 4')),
      body: const Center(child: Text('Nội dung Câu 4')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau5Placeholder extends StatelessWidget {
  const _Cau5Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 5')),
      body: const Center(child: Text('Nội dung Câu 5')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau6Placeholder extends StatelessWidget {
  const _Cau6Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 6')),
      body: const Center(child: Text('Nội dung Câu 6')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
class _Cau7Placeholder extends StatelessWidget {
  const _Cau7Placeholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câu 7')),
      body: const Center(child: Text('Nội dung Câu 7')),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text('6451071037 - Ngô Minh Khôi',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
