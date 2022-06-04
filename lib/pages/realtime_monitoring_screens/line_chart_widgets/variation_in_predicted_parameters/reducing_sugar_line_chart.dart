import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReducingSugarLineChartWidget extends StatefulWidget {
  const ReducingSugarLineChartWidget({Key? key}) : super(key: key);

  @override
  State<ReducingSugarLineChartWidget> createState() => _ReducingSugarLineChartWidgetState();
}

class _ReducingSugarLineChartWidgetState extends State<ReducingSugarLineChartWidget> {



  final List<FlSpot> _lineChartData = [
    const FlSpot(0, 0.0300),
    const FlSpot(1, 0.0300),
    const FlSpot(2, 0.0302),
    const FlSpot(3, 0.0302),
    const FlSpot(4, 0.0304),
    const FlSpot(5, 0.0304),
    const FlSpot(6, 0.0304),
    const FlSpot(7, 0.0306),
    const FlSpot(8, 0.0306),
    const FlSpot(9, 0.0306),
    const FlSpot(10, 0.0308),
    const FlSpot(11, 0.0306),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            minX:0,
            maxX: 11,
            minY: 0.0300,
            maxY: 0.0310,
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
    if(value == 0.0300){
      text = '0.0300';
    } else if(value == 0.0302){
      text  = '0.0302';
    } else if( value == 0.0304){
      text  = '0.0304';
    } else if( value == 0.0306){
      text  = '0.0306';
    } else if( value == 0.0308){
      text  = '0.0308';
    } else if( value == 0.0310){
      text  = '0.0310';
    } else { text = '';}

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
