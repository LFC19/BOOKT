import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/reading_log.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';
import '../utils/date_util.dart';
import 'package:intl/date_symbol_data_local.dart';


enum ChartRange { week, month }

class ChartScreen extends StatefulWidget {
  final String userId;
  const ChartScreen({super.key, required this.userId});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  ChartRange _range = ChartRange.week;
  final _fs = FirestoreService();

  DateTime get _start {
    final now = DateTime.now();
    if (_range == ChartRange.week) {
      return DateUtilsCustom.startOfWeek(now);
    } else {
      return DateUtilsCustom.startOfMonth(now);
    }
  }

  DateTime get _end {
    final now = DateTime.now();
    if (_range == ChartRange.week) {
      return DateUtilsCustom.endOfWeek(now);
    } else {
      return DateUtilsCustom.endOfMonth(now);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReadingLog>>(
      stream: _fs.logsByUserStream(widget.userId, start: _start, end: _end),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];

        // 날짜별 합계
        final map = <String, int>{};
        for (final log in logs) {
          final key = DateFormat('yyyy-MM-dd')
              .format(DateTime(log.date.year, log.date.month, log.date.day));
          map[key] = (map[key] ?? 0) + log.pagesRead;
        }

        final entries = <BarChartGroupData>[];
        final labels = <String>[];

        if (_range == ChartRange.week) {
          // 월~일 7개 막대
          for (int i = 0; i < 7; i++) {
            final d = _start.add(Duration(days: i));
            final key = DateFormat('yyyy-MM-dd').format(d);
            final value = (map[key] ?? 0).toDouble();
            entries.add(BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: value, width: 14),
            ]));
            labels.add(DateFormat('E', 'ko_KR').format(d)); // 요일
          }
        } else {
          // 해당 월 일수만큼
          final days = DateUtils.getDaysInMonth(_start.year, _start.month);
          for (int i = 0; i < days; i++) {
            final d = DateTime(_start.year, _start.month, i + 1);
            final key = DateFormat('yyyy-MM-dd').format(d);
            final value = (map[key] ?? 0).toDouble();
            entries.add(BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: value, width: 8),
            ]));
            labels.add('${i + 1}');
          }
        }

        final total = logs.fold<int>(0, (sum, e) => sum + e.pagesRead);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    _range == ChartRange.week
                        ? '이번 주 총 페이지: $total'
                        : '이번 달 총 페이지: $total',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  SegmentedButton<ChartRange>(
                    segments: const [
                      ButtonSegment(value: ChartRange.week, label: Text('주간')),
                      ButtonSegment(value: ChartRange.month, label: Text('월간')),
                    ],
                    selected: {_range},
                    onSelectionChanged: (s) {
                      setState(() => _range = s.first);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: entries.isEmpty
                    ? const Center(child: Text('데이터가 없습니다.'))
                    : BarChart(
                  BarChartData(
                    barGroups: entries,
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 36),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final text = (index >= 0 && index < labels.length)
                                ? labels[index]
                                : '';
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: const TextStyle(fontSize: 10)),
                            );
                          },
                          reservedSize: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
