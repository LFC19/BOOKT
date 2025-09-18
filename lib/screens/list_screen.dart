import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _fs = FirestoreService();
  final _formKey = GlobalKey<FormState>();
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
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
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
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("로그인이 필요합니다."));
    }

    return Column(
      children: [
        // 입력폼
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '책 제목',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? '책 제목을 입력하세요' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pagesController,
                  decoration: const InputDecoration(
                    labelText: '읽은 페이지 수',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return '페이지 수 입력';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return '1 이상의 정수 입력';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: const Text('날짜 선택'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("저장"),
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
                return Center(child: Text("에러: ${snapshot.error}"));
              }
              final logs = snapshot.data ?? [];
              if (logs.isEmpty) {
                return const Center(child: Text("기록이 없습니다."));
              }
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, i) {
                  final log = logs[i];
                  return ListTile(
                    title: Text(log.bookTitle),
                    subtitle: Text(
                      "${log.pagesRead} 페이지 - ${DateFormat('yyyy-MM-dd').format(log.date)}",
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

