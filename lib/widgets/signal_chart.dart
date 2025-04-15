// lib/widgets/signal_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/scan_data.dart';

class SignalChart extends StatelessWidget {
  final List<SignalSample> samples;
  final Color lineColor;

  const SignalChart({Key? key, required this.samples, required this.lineColor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return Center(
        child: Text('No data', style: TextStyle(color: Colors.grey)),
      );
    }

    // Convert to FlSpot (x: seconds since first sample, y: RSSI)
    final firstTs = samples.first.timestamp;
    final spots =
        samples.map((s) {
          final x = s.timestamp.difference(firstTs).inSeconds.toDouble();
          final y = s.rssi.toDouble();
          return FlSpot(x, y);
        }).toList();

    // Compute span
    final span = spots.last.x - spots.first.x;
    // Ensure a non-zero interval
    final interval = span > 0 ? span / 4 : 1.0;

    return LineChart(
      LineChartData(
        minY: -100,
        maxY: 0,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: samples.length > 1, // hide if only one point
              reservedSize: 30,
              interval: interval,
              getTitlesWidget: (value, meta) {
                final ts = firstTs.add(Duration(seconds: value.toInt()));
                final label =
                    "${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}";
                return Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 20),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
