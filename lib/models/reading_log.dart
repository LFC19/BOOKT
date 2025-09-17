import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingLog {
  final String id;
  final String userId;
  final String bookTitle;
  final int pagesRead;
  final DateTime date; // 일자 단위 사용

  ReadingLog({
    required this.id,
    required this.userId,
    required this.bookTitle,
    required this.pagesRead,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookTitle': bookTitle,
      'pagesRead': pagesRead,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
    };
  }

  factory ReadingLog.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['date'] as Timestamp;
    return ReadingLog(
      id: doc.id,
      userId: data['userId'] as String,
      bookTitle: data['bookTitle'] as String,
      pagesRead: (data['pagesRead'] as num).toInt(),
      date: ts.toDate(),
    );
  }
}
