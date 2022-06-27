import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../common/predicted_line_chart_stream.dart';
import '../../../../common/utility_functions.dart';
import '../../../../models/potato_data_model.dart';

class WeightLineChartWidget extends StatefulWidget {
  const WeightLineChartWidget({Key? key}) : super(key: key);

  @override
  State<WeightLineChartWidget> createState() => _WeightLineChartWidgetState();
}

class _WeightLineChartWidgetState extends State<WeightLineChartWidget> {
  late double maxAxisLabel;
  late double minAxisLabel;
  late List<FlSpot> flattenedData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getData(parameter: 'Weight', noOfDigitsAfterDecimal: 1),
        builder: (context,snapshot) {
          if(snapshot.hasData) {

          //storing snapshot object as List<FlSpot>
            List<List<FlSpot>> data = snapshot.data as List<List<FlSpot>>;
            flattenedData = data.expand((element) => element).toList();
            minAxisLabel = roundToPrevTwo(getMin(flattenedData));
            maxAxisLabel = roundToNextTwo(getMax(flattenedData));
            if(minAxisLabel == maxAxisLabel && maxAxisLabel == 0){
              maxAxisLabel =1;
            }

          return LineChart(
              LineChartData(
                  minX: 0,
                  maxX: data[1].last.x,
                  minY: minAxisLabel,
                  maxY: maxAxisLabel,
                  gridData: FlGridData(
                    show: false,
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
                      spots: data[0],
                      isCurved: false,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[200]!,
                          Colors.red[500]!,
                        ],
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red[200]!,
                            Colors.red[500]!,
                          ].map((color) => color.withOpacity(0.3)).toList(),
                        ),
                      ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[1],
                      isCurved: false,
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow[200]!,
                          Colors.yellow[500]!,
                        ],
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow[200]!,
                            Colors.yellow[500]!,
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
                          interval: 0.25,
                          reservedSize: 40,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          getTitlesWidget: bottomTitleWidgets,
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                        )
                    ),
                  )
              ));
              }
              else if (snapshot.hasError)
          return Text("Something went wrong");
          else
            return Center(child: CircularProgressIndicator(),);
        }
          );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(getAxisLabel(value: value, maxAxisLabel: maxAxisLabel, minAxisLabel: minAxisLabel, flattenedData: flattenedData, symbol: '', digitsAfterDecimal: 0), style: getStyle(), textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value.toInt() % 5 == 0) {
        text = Text(value.toStringAsFixed(0), style: style);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
