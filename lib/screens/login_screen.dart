import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                "독서 습관 기록지",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "책과 함께 성장하는 하루 📚",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                  elevation: 2,
                ),
                icon: const Icon(Icons.account_circle, color: Colors.black87), // ✅ 아이콘 사용
                label: const Text(
                  "Google 계정으로 로그인",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  final user = await _authService.signInWithGoogle();
                  if (user != null && context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


