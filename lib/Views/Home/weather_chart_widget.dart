import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherChartWidget extends StatelessWidget {
  final List<double> hourlyTemperatures;

  const WeatherChartWidget({super.key, required this.hourlyTemperatures});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: hourlyTemperatures
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: Colors.blueAccent,
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            )
          ],
          titlesData: const FlTitlesData(show: false),
        ),
      ),
    );
  }
}
