import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {

  //Working future
  // Future<List<FlSpot>> getData() async{
  //   http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
  //   List temperatureData = jsonDecode(response.body);
  //   List<FlSpot> lineChartData = [];
  //   double index =0;
  //   temperatureData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["T"]!))));
  //   return lineChartData;
  // }

  Stream<List<FlSpot>> getData() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
      List temperatureData = jsonDecode(response.body);
      List<FlSpot> lineChartData = [];
      double index =0;
      temperatureData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["T"]!))));
      yield lineChartData;
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getData(),
      builder: (context,snapshot) {
        if(snapshot.hasData) {

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

          return Stack(
            clipBehavior: Clip.none,
            children: [
              LineChart(
                LineChartData(
                    minX: 0,
                    maxX: roundToNextTens(data.length),
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
                            interval: 2,
                            reservedSize: 40,
                          )
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: bottomTitleWidgets,
                            showTitles: true,
                            interval: 10,
                            reservedSize: 40,

                          )
                      ),
                    )
                )
              ),
              Positioned(
                top: -4,
                right: -8,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0.0),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Icon(Icons.refresh,color: Colors.white70,),
                ),
              ),
              Positioned(
                left: 50,
                  top: 10,
                  child: Text(data.length.toString())),
            ]
          );
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

    if(value.toInt()%2 == 0){
      text = '${value.toStringAsFixed(0)} °C';
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
    if(value.toInt()%10 == 0){
      text = Text(value.toStringAsFixed(0), style: style,);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
