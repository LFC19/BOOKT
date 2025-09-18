import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'chart_screen.dart';
import 'add_log_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final screens = [
      ChartScreen(userId: widget.userId),     // 📊 차트
      AddLogScreen(userId: widget.userId),    // ✍ 기록 추가
      CalendarScreen(userId: widget.userId),  // 📅 캘린더
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("독서 습관 트래커"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ 사용자 정보 헤더
          if (user != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    radius: 30,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? "이름 없음",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(user.email ?? "이메일 없음"),
                    ],
                  ),
                ],
              ),
            ),

          // ✅ 탭 컨텐츠
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "차트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "기록",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "캘린더",
          ),
        ],
      ),
    );
  }
}

