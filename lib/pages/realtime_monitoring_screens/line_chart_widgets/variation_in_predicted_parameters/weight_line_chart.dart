import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../models/potato_data_model.dart';

class WeightLineChartWidget extends StatefulWidget {
  const WeightLineChartWidget({Key? key}) : super(key: key);

  @override
  State<WeightLineChartWidget> createState() => _WeightLineChartWidgetState();
}

class _WeightLineChartWidgetState extends State<WeightLineChartWidget> {

  Stream<List<List<FlSpot>>> getData() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/weight-data'));
      List sensorData = jsonDecode(response.body);
      List<FlSpot> lineChartData = [];
      List<FlSpot> predictedLineChartData = [];
      double index =0;
      sensorData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["Weight"]!))));
      double T = double.parse(sensorData.last["T"]);
      double rh = double.parse(sensorData.last["RH"]);
      predictedLineChartData.add(lineChartData.last);
      for(; index< sensorData.length + 10; index++){
        double initialWeight = PotatoData.getWeightloss(double.parse(sensorData.last["Weight"]),PotatoData.getTranspirationRate(T, rh) ,index);
        initialWeight = double.parse(initialWeight.toStringAsFixed(2));
        predictedLineChartData.add(FlSpot(index,initialWeight));
      }
      yield [lineChartData,predictedLineChartData];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getData(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {

          //storing snapshot object as List<FlSpot>
            List<List<FlSpot>> data = snapshot.data as List<List<FlSpot>>;

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
                  maxX: data[0].length.toDouble() + data[1].length.toDouble() -2,
                  minY: minY(data[1])-5,
                  maxY: maxY(data[0])+5,
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
                      spots: data[0],
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
                    LineChartBarData(
                      spots: data[1],
                      isCurved: true,
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
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value.toInt() % 10 == 0) {
        text = value.toString();
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
