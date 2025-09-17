import 'package:flutter/material.dart';
import '../models/reading_log.dart';
import 'package:intl/intl.dart';

class LogCard extends StatelessWidget {
  final ReadingLog log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LogCard({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(log.date);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(
          log.bookTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$dateStr • ${log.pagesRead}p'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') onEdit();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('수정')),
            PopupMenuItem(value: 'delete', child: Text('삭제')),
          ],
        ),
      ),
    );
  }
}
