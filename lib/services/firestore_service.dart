import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reading_log.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  static const collection = 'reading_logs';

  Future<void> addLog(ReadingLog log) async {
    await _db.collection(collection).add(log.toMap());
  }

  Future<void> updateLog(ReadingLog log) async {
    await _db.collection(collection).doc(log.id).update(log.toMap());
  }

  Future<void> deleteLog(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<ReadingLog>> logsByUserStream(String userId,
      {DateTime? start, DateTime? end}) {
    Query query = _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true);

    if (start != null) {
      query =
          query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(start.year, start.month, start.day)));
    }
    if (end != null) {
      final endNext = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
      query =
          query.where('date', isLessThan: Timestamp.fromDate(endNext));
    }

    return query.snapshots().map((snap) =>
        snap.docs.map((d) => ReadingLog.fromDoc(d)).toList());
  }

  Stream<List<ReadingLog>> logsByDate(String userId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final endNext = start.add(const Duration(days: 1));
    return _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(endNext))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ReadingLog.fromDoc(d)).toList());
  }
}
