import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Google로 로그인'),
          onPressed: () async {
            final User? user = await _authService.signInWithGoogle();
            if (user == null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('로그인에 실패했어요. 다시 시도해주세요.')),
              );
            }
            // ✅ 별도 네비게이션 불필요: authStateChanges()로 main에서 화면이 교체됩니다.
          },
        ),
      ),
    );
  }
}
