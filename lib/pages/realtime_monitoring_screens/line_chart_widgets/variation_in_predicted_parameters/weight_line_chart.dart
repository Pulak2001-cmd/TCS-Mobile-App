import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeightLineChartWidget extends StatefulWidget {
  const WeightLineChartWidget({Key? key}) : super(key: key);

  @override
  State<WeightLineChartWidget> createState() => _WeightLineChartWidgetState();
}

class _WeightLineChartWidgetState extends State<WeightLineChartWidget> {

  Stream<List<FlSpot>> getData() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/weight-data'));
      List temperatureData = jsonDecode(response.body);
      List<FlSpot> lineChartData = [];
      double index =0;
      temperatureData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["Weight"]!))));
      for(; index< temperatureData.length + 10; index++){
        lineChartData.add(FlSpot(index++, double.parse(temperatureData[index.toInt()])));
      }
      yield lineChartData;
    }
  }

  final List<FlSpot> _lineChartData = [
    const FlSpot(0, 999),
    const FlSpot(1, 990),
    const FlSpot(2, 981),
    const FlSpot(3, 973),
    const FlSpot(4, 968),
    const FlSpot(5, 967),
    const FlSpot(6, 966.5),
    const FlSpot(7, 966.4),
    const FlSpot(8, 966.3),
    const FlSpot(9, 966.2),
    const FlSpot(10, 966.1),
    const FlSpot(11, 966.1),
  ];


  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            minX:0,
            maxX: 11,
            minY: 960,
            maxY: 1000,
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
      case 960:
        text = '960';
        break;
      case 970:
        text = '970';
        break;
      case 980:
        text = '980';
        break;
      case 990:
        text = '990';
        break;
      case 1000:
        text = '1000';
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
