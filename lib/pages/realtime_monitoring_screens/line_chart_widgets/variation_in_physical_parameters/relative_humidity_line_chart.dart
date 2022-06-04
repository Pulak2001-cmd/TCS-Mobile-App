import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelativeHumidityLineChartWidget extends StatefulWidget {
  const RelativeHumidityLineChartWidget({Key? key}) : super(key: key);

  @override
  State<RelativeHumidityLineChartWidget> createState() => _RelativeHumidityLineChartWidgetState();
}

class _RelativeHumidityLineChartWidgetState extends State<RelativeHumidityLineChartWidget> {

  Stream<List<FlSpot>> getData() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/relative-humidity-data'));
      List relativeHumidityData = jsonDecode(response.body);
      List<FlSpot> lineChartData = [];
      double index =0;
      relativeHumidityData.forEach((entry) => lineChartData.add(FlSpot(index++, double.parse(entry["RH"]!))));
      yield lineChartData;
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FlSpot>> (
      stream: getData(),
      builder: (context, snapshot){
        if(snapshot.hasData){

          //storing snapshot object as List<FlSpot>
          List<FlSpot> data = snapshot.data as List<FlSpot>;

          //Utility functions
          double minY(List<FlSpot> data){
            double min = data.first.y;
            for(var point in data){
              if(point.y < min) {
                min = point.y;
              } else {
                continue;
              }
            }
            return min;
          }
          double maxY(List<FlSpot> data){
            double max = data.first.y;
            for(var point in data){
              if(point.y > max) {
                max = point.y;
              } else {
                continue;
              }
            }
            return max;
          }
          double roundToNextTens(int length){
            double temp = double.parse((length/10).truncate().toString())*10 + 10;
            return temp;
          }

          return LineChart(
              LineChartData(
                  minX:0,
                  maxX: roundToNextTens(data.length),
                  minY: 0,
                  maxY: 100,
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
        } else if(snapshot.hasError){
          return Text("something went wrong");
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value.toInt() % 20 == 0) {
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
    if (value.toInt() % 10 == 0) {
        text = Text(value.toStringAsFixed(0), style: style);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
