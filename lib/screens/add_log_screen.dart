import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/reading_log.dart';
import 'package:my_app/services/firestore_service.dart';

class AddLogScreen extends StatefulWidget {
  final String userId;
  final ReadingLog? editing;

  const AddLogScreen({super.key, required this.userId, this.editing});

  @override
  State<AddLogScreen> createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  final _titleController = TextEditingController();
  final _pagesController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _fs = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editing != null) {
      _titleController.text = widget.editing!.bookTitle;
      _pagesController.text = widget.editing!.pagesRead.toString();
      _noteController.text = widget.editing!.note ?? '';
      _selectedDate = widget.editing!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pagesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final pages = int.parse(_pagesController.text.trim());
    final note = _noteController.text.trim();

    final log = ReadingLog(
      id: widget.editing?.id ?? '',
      userId: widget.userId,
      bookTitle: title,
      pagesRead: pages,
      date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      note: note,
    );

    if (widget.editing == null) {
      await _fs.addLog(log);
    } else {
      await _fs.updateLog(log);
    }

    if (mounted) Navigator.pop(context);
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
    final isEdit = widget.editing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '기록 수정' : '기록 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '책 제목',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? '책 제목을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(
                  labelText: '읽은 페이지 수',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '페이지 수 입력';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return '1 이상의 정수';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: '감상평 (선택)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '날짜',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _save,
                child: Text(isEdit ? '수정 완료' : '저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
