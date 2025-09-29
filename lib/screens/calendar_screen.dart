import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reading_log.dart';
import '../services/firestore_service.dart';
import 'add_log_screen.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;
  const CalendarScreen({super.key, required this.userId});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _fs = FirestoreService();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2020, 1, 1),
          lastDay: DateTime(2100, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) =>
          day.year == _selectedDay.year &&
              day.month == _selectedDay.month &&
              day.day == _selectedDay.day,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
              titleCentered: true, formatButtonVisible: false),
        ),
        Expanded(
          child: StreamBuilder<List<ReadingLog>>(
            stream: _fs.logsByDate(widget.userId, _selectedDay),
            builder: (context, snap) {
              final logs = snap.data ?? [];
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (logs.isEmpty) {
                return const Center(child: Text('이 날짜의 기록이 없습니다.'));
              }
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, i) {
                  final log = logs[i];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: Text(
                        log.bookTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${DateFormat('yyyy-MM-dd').format(log.date)} • ${log.pagesRead}p"),
                          if (log.note != null && log.note!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              "📖 ${log.note!}",
                              style:
                              const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddLogScreen(
                                    userId: widget.userId, editing: log),
                              ),
                            );
                          } else if (value == 'delete') {
                            await _fs.deleteLog(log.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text("수정")),
                          const PopupMenuItem(
                              value: 'delete', child: Text("삭제")),
                        ],
                      ),
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
