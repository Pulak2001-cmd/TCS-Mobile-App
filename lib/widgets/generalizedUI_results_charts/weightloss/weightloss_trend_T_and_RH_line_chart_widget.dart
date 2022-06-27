import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:scidart/numdart.dart';
import 'dart:math';

class WeightlossTrendAtTAndRHLineChartWidget extends StatefulWidget {
  double T;
  double rh;
  double currentWeight;

   WeightlossTrendAtTAndRHLineChartWidget({Key? key, required this.rh, required this.T, required this.currentWeight }) : super(key: key);

  @override
  State<WeightlossTrendAtTAndRHLineChartWidget> createState() => _WeightlossTrendAtTAndRHLineChartWidgetState();
}

class _WeightlossTrendAtTAndRHLineChartWidgetState extends State<WeightlossTrendAtTAndRHLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 20);
  List<double?> weightloss = [];
  double? gap;

  Future<List<FlSpot>> futureLineChartData(Array timeVec, List<double?> weightloss) async {
    List<FlSpot> lineChartData = [];
    for (var time in timeVec){
      double point = double.parse(PotatoData.getWeightloss(widget.currentWeight, PotatoData.getTranspirationRate(widget.T, widget.rh), time).toStringAsFixed(1));
      weightloss.add(point);
    }
    for(var i = 0; i< timeVec.length; i++)
    lineChartData.add( FlSpot(timeVec[i], weightloss[i] ?? 0));
    return lineChartData;
  }

  double calculateAxisTitlesGap(double maxValue, double minValue){
    double gap;

    double diff = roundToNextTens(maxValue) - roundToPrevTens(minValue);
    gap = diff/4;

    return gap;
  }

  double roundToPrevTens(double length){
    double temp = double.parse((length/10).truncate().toString())*10;
    return temp;
  }

  double roundToNextTens(double length){
    double temp = double.parse((length/10).truncate().toString())*10 + 10;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureLineChartData(timeVec, weightloss),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<FlSpot> data = snapshot.data as List<FlSpot>;
            return LineChart(
                LineChartData(
                    minX:0,
                    maxX: 100,
                    minY: roundToPrevTens(data.last.y),
                    maxY: roundToNextTens(data.first.y),
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
                        spots: data,
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
                            interval: 20,
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
    if(value.toInt()%20 == 0) {
        text = '${value.toStringAsFixed(0)} %';
    } else {
      text = '';
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
