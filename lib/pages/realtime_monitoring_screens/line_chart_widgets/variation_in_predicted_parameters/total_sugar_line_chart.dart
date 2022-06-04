import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalSugarLineChartWidget extends StatefulWidget {
  const TotalSugarLineChartWidget({Key? key}) : super(key: key);

  @override
  State<TotalSugarLineChartWidget> createState() => _TotalSugarLineChartWidgetState();
}

class _TotalSugarLineChartWidgetState extends State<TotalSugarLineChartWidget> {



  final List<FlSpot> _lineChartData = [
    const FlSpot(0, 8),
    const FlSpot(1, 5),
    const FlSpot(2, 7),
    const FlSpot(3, 4),
    const FlSpot(4, 3.8),
    const FlSpot(5, 2.2),
    const FlSpot(6, 6.3),
    const FlSpot(7, 5.4),
    const FlSpot(8, 1),
    const FlSpot(9, 4),
    const FlSpot(10, 8.8),
    const FlSpot(11, 5.2),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            minX:0,
            maxX: 11,
            minY: 0,
            maxY: 10,
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (val) {
                return FlLine(
                  color: Colors.blueGrey[100]?.withOpacity(0.3),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (val) {
                return FlLine(
                  color: Colors.blueGrey[100]?.withOpacity(0.3),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.blueGrey[100]!,
                width: 1,
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _lineChartData,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey[200]!,
                    Colors.blueGrey[500]!,
                  ],
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueGrey[200]!,
                      Colors.blueGrey[500]!,
                    ].map((color) => color.withOpacity(0.3)).toList(),
                  ),
                ),
                dotData: FlDotData(
                  show: false,
                ),
              )
            ],
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  )
              ),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  )
              ),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: leftTitleWidgets,
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                  )
              ),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: bottomTitleWidgets,
                    showTitles: true,
                    interval: 2,
                    reservedSize: 40,
                  )
              ),
            )
        )
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '0.20';
        break;
      case 4:
        text = '0.24';
        break;
      case 6:
        text = '0.28';
        break;
      case 8:
        text = '0.32';
        break;
      case 10:
        text = '0.34';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
