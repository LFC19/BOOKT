import 'package:flutter/material.dart';
import '../models/reading_log.dart';
import '../services/firestore_service.dart';
import '../widgets/log_card.dart';
import 'add_log_screen.dart';

class ListScreen extends StatelessWidget {
  final String userId;
  const ListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();

    return StreamBuilder<List<ReadingLog>>(
      stream: fs.logsByUserStream(userId),
      builder: (context, snap) {
        final logs = snap.data ?? [];
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (logs.isEmpty) {
          return Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddLogScreen(userId: userId),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('첫 기록을 추가해 보세요'),
            ),
          );
        }
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (_, i) {
            final log = logs[i];
            return LogCard(
              log: log,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddLogScreen(userId: userId, editing: log),
                  ),
                );
              },
              onDelete: () async {
                await fs.deleteLog(log.id);
              },
            );
          },
        );
      },
    );
  }
}
