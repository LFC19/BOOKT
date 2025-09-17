import 'package:flutter/material.dart';
import 'add_log_screen.dart';
import 'list_screen.dart';
import 'chart_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ListScreen(userId: widget.userId),
      ChartScreen(userId: widget.userId),
      CalendarScreen(userId: widget.userId),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('독서 습관 트래커')),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: '기록'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: '차트'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: '캘린더'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
      floatingActionButton: (_index == 0)
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddLogScreen(userId: widget.userId),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('기록 추가'),
      )
          : null,
    );
  }
}
