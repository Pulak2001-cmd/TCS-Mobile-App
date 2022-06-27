import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:scidart/numdart.dart';
import 'dart:math';

import '../../../common/utility_functions.dart';

class TotalSugarTrendAtTAndRHLineChartWidget extends StatefulWidget {
  PotatoData selectedVariety;
  double currentRS;
  double T;

  TotalSugarTrendAtTAndRHLineChartWidget({Key? key,required this.selectedVariety, required this.currentRS, required this.T }) : super(key: key);

  @override
  State<TotalSugarTrendAtTAndRHLineChartWidget> createState() => _TotalSugarTrendAtTAndRHLineChartWidgetState();
}

class _TotalSugarTrendAtTAndRHLineChartWidgetState extends State<TotalSugarTrendAtTAndRHLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 20);
  List<double?> totalSugar = [];

  Future<List<FlSpot>> futureLineChartData(Array timeVec, List<double?> totalSugar) async {
    List<FlSpot> lineChartData = [];
    for (var time in timeVec){
      var dataPoint = double.parse((await widget.selectedVariety.calculate_tot_sugar(time, widget.T, widget.currentRS)).toStringAsFixed(2));
      totalSugar.add(dataPoint);
    }
    for(var i = 0; i< timeVec.length; i++)
      lineChartData.add( FlSpot(timeVec[i], totalSugar[i] ?? 0));
    return lineChartData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLineChartData(timeVec, totalSugar),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<FlSpot> flattenedData = snapshot.data as List<FlSpot>;
          return LineChart(
              LineChartData(
                  minX:0,
                  maxX: 100,
                  minY: roundToPrevTwo(getMin(flattenedData)),
                  maxY: roundToNextTwo(getMax(flattenedData)),
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
                      spots: flattenedData,
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
                    ),
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
                          interval: axisLabelsInterval(flattenedData),
                          reservedSize: 40,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          getTitlesWidget: bottomTitleWidgets,
                          showTitles: true,
                          interval: 20,
                          reservedSize: 25,
                        )
                    ),
                  )
              )
          );
        } else if (snapshot.hasError){
          return Text('Something went wrong');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    text = '${value.toStringAsFixed(1)}';
    return Text(text, style: style, textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if(value.toInt()%20 == 0) {
      text = Text('${value.toStringAsFixed(0)}', style: style,);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
