import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingLog {
  final String id;
  final String userId;
  final String bookTitle;
  final int pagesRead;
  final DateTime date;
  final String? note;

  ReadingLog({
    required this.id,
    required this.userId,
    required this.bookTitle,
    required this.pagesRead,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookTitle': bookTitle,
      'pagesRead': pagesRead,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      if (note != null && note!.isNotEmpty) 'note': note,
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
      note: data['note'] as String?,
    );
  }

}
