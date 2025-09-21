import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chart_screen.dart';
import 'list_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      ChartScreen(userId: widget.user.uid),
      const RecordListScreen(),
      CalendarScreen(userId: widget.user.uid),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: widget.user.photoURL != null
                  ? NetworkImage(widget.user.photoURL!)
                  : null,
              child: widget.user.photoURL == null
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
            const SizedBox(width: 8),
            // ✨ 이름 or 이메일
            Text(
              widget.user.displayName ?? widget.user.email ?? "사용자",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),

      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "차트"),
          NavigationDestination(icon: Icon(Icons.book), label: "기록"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "캘린더"),
        ],
        onDestinationSelected: (i) {
          setState(() => _index = i);
        },
      ),
    );
  }
}


