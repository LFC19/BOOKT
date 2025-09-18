import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/reading_log.dart';

class ListScreen extends StatelessWidget {
  final String userId;
  const ListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final _fs = FirestoreService();

    return StreamBuilder<List<ReadingLog>>(
      stream: _fs.logsByUserStream(userId),
      builder: (context, snapshot) {
        // 1. 에러 처리
        if (snapshot.hasError) {
          return Center(child: Text("에러 발생: ${snapshot.error}"));
        }

        // 2. 로딩 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 3. 데이터 확인
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("저장된 기록이 없습니다."));
        }

        final logs = snapshot.data!;
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              title: Text(log.bookTitle),
              subtitle: Text("${log.pagesRead} 페이지 - ${log.date.toLocal()}"),
            );
          },
        );
      },
    );
  }
}
