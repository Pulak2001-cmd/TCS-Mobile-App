import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:scidart/numdart.dart';
import 'dart:math';

import '../../../common/utility_functions.dart';

class RSTrendTLineChartWidget extends StatefulWidget {
  final PotatoData selectedVariety;
  final double currentRS;
  final double T;

   RSTrendTLineChartWidget({Key? key,required this.selectedVariety, required this.currentRS, required this.T }) : super(key: key);

  @override
  State<RSTrendTLineChartWidget> createState() => _RSTrendTLineChartWidgetState();
}

class _RSTrendTLineChartWidgetState extends State<RSTrendTLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 20);
  List<double?> reducing_sugar = [];

  Future<List<FlSpot>> futureLineChartData(Array timeVec, List<double?> reducing_sugar) async {
    List<FlSpot> lineChartData = [];
    for (var time in timeVec){
      double? result = await widget.selectedVariety.RS_day(time, widget.T, widget.currentRS);
      result = double.parse((result?.toStringAsFixed(5))!);
      reducing_sugar.add(result);
    }
    for(var i = 0; i< timeVec.length; i++)
    lineChartData.add( FlSpot(timeVec[i], reducing_sugar[i] ?? 0));
    return lineChartData;
  }

  late double maxAxisLabel;
  late double minAxisLabel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureLineChartData(timeVec, reducing_sugar),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<FlSpot> flattenedData = snapshot.data as List<FlSpot>;
            minAxisLabel = roundToPrevTwo(getMin(flattenedData));
            maxAxisLabel = roundToNextTwo(getMax(flattenedData));
            return LineChart(
                LineChartData(
                    minX:0,
                    maxX: 100,
                    minY: minAxisLabel,
                    maxY: 0.5,
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (val) {
                        if(val == 0.3){
                          return FlLine(
                            color: Colors.redAccent[100]?.withOpacity(0.3),
                            strokeWidth: 1,
                          );
                        } else {
                          return FlLine(
                            color: Colors.blueGrey[100]?.withOpacity(0.3),
                            strokeWidth: 1,
                          );
                        }
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
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0.3,
                          color: Colors.red,
                          strokeWidth: 1,
                        )
                      ]
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        /// clipping data above the 0.5% RS value, very complex expression should be broken down and simplified
                        spots: (snapshot.data as List<FlSpot>).where((element) => element.y <= 0.5).toList().last.y <= 0.5 ? (snapshot.data as List<FlSpot>).where((element) => element.y <= 0.5).toList() : [...(snapshot.data as List<FlSpot>).where((element) => element.y <= 0.5).toList(), FlSpot((snapshot.data as List<FlSpot>).firstWhere((element) => element.y > 0.5).x, 0.5)],
                        // spots: (snapshot.data as List<FlSpot>),
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
                            // interval: axisLabelsInterval(flattenedData),
                            interval: 0.1,
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
    if(value == maxAxisLabel || value == minAxisLabel){
      text = '${value.toStringAsFixed(1)} %';
    } else {
      double textValue = value + minAxisLabel;
      text = '${textValue.toStringAsFixed(1)} %';
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
    if(value.toInt()%20 == 0) {
      text = Text('${value.toStringAsFixed(0)}', style: style,);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
