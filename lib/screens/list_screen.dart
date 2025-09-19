import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reading_log.dart';
import '../services/firestore_service.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  final _titleController = TextEditingController();
  final _pagesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _fs = FirestoreService();

  DateTime _selectedDate = DateTime.now();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final log = ReadingLog(
      id: '',
      userId: user.uid,
      bookTitle: _titleController.text.trim(),
      pagesRead: int.parse(_pagesController.text.trim()),
      date: _selectedDate,
    );

    await _fs.addLog(log);

    // 입력창 초기화
    _titleController.clear();
    _pagesController.clear();
    setState(() => _selectedDate = DateTime.now());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("로그인이 필요합니다."));
    }

    return Scaffold(
      body: Column(
        children: [
          // 입력 폼
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "책 제목",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book_outlined),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "책 제목을 입력하세요" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pagesController,
                    decoration: const InputDecoration(
                      labelText: "읽은 페이지 수",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "페이지 수 입력";
                      final n = int.tryParse(v);
                      if (n == null || n <= 0) return "1 이상의 정수 입력";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat("yyyy-MM-dd").format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.date_range),
                        label: const Text("날짜 선택"),
                      ),
                      ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text("저장"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          // 기록 리스트
          Expanded(
            child: StreamBuilder<List<ReadingLog>>(
              stream: _fs.logsByUserStream(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("에러 발생: ${snapshot.error}"));
                }

                final logs = snapshot.data ?? [];
                if (logs.isEmpty) {
                  return const Center(child: Text("저장된 기록이 없습니다."));
                }

                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, i) {
                    final log = logs[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.book, color: Colors.blue),
                        title: Text(
                          log.bookTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${log.pagesRead} 페이지\n${DateFormat('yyyy-MM-dd').format(log.date)}",
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

