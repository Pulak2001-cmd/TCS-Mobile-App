import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../common/utility_functions.dart';
import '../models/DHT22_sensor_data_model.dart';

class LineChartWidget extends StatefulWidget {
  final String parameter;
  final DatabaseReference dataRef;
  const LineChartWidget({Key? key, required this.parameter, required this.dataRef}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late List<FlSpot> data;
  late double maxYAxisLabel;
  late double minYAxisLabel;
  late double maxXAxisLabel;
  late double minXAxisLabel;

  Stream<List<FlSpot>> getData() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
      List temperatureData = jsonDecode(response.body);
      List<FlSpot> lineChartData = [];
      for(int index =0; index < temperatureData.length; index ++) {
        //TODO: this run continuously with the stream, crate a method to check for updates
        // if(double.parse(temperatureData[index]["T"]) > 5.0){
        //   Provider.of<AlertProvider>(context,listen: false).addAlert('Temperature greater than critical limit');
        // }
        lineChartData.add(FlSpot(index.toDouble(), double.parse(temperatureData[index]["T"]!)));
      }
      yield lineChartData;
    }
  }

  Future<List<FlSpot>> getSensorReadings(DatabaseReference dataRef) async{
    List<FlSpot> sensorReadings = [];
    List<DHT22SensorData> sensorData = [];
    DataSnapshot data = await dataRef.get();
    List<DataSnapshot> dataList = data.children.toList();
    dataList.forEach((reading) {
      if(DHT22SensorData.checkValidValue(reading.value as Map<dynamic,dynamic>)){
        DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
        temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
        sensorData.add(temp);
      }

    });
    List<Map<String, double>> avgTemperatureByHoursMaps = calculateAvgTemperatureAndHumidityByHours(sensorData, hours: 4);
    avgTemperatureByHoursMaps.forEach((dataPoint) {
      /// Showing sensor data according to the passed parameter
      switch(widget.parameter){
        case 'temperature': {
          if(dataPoint['avgT'] != -1000.0){
            sensorReadings.add(FlSpot(dataPoint['index']!, dataPoint['avgT']!));
          }
          break;
        }
        case 'relative humidity': {
          if(dataPoint['avgRH'] != -1000.0){
            sensorReadings.add(FlSpot(dataPoint['index']!, dataPoint['avgRH']!));
          }
          break;
        }
        case 'ethylene conc': {
          if(dataPoint['avgEC'] != -1000.0 && dataPoint['avgEC'] != 0){
            sensorReadings.add(FlSpot(dataPoint['index']!, dataPoint['avgEC']!));
          }
          break;
        }
        case 'co2 conc': {
          if(dataPoint['avgCC'] != -1000.0 && dataPoint['avgCC'] != 0){
            sensorReadings.add(FlSpot(dataPoint['index']!, dataPoint['avgCC']!));
          }
          break;
        }
      }

    });
    return sensorReadings;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSensorReadings(widget.dataRef),
      builder: (context,snapshot) {
        if(snapshot.hasData) {

          //storing snapshot object as List<FlSpot>
          data = snapshot.data as List<FlSpot>;
          minYAxisLabel = roundToPrevTwo(getMin(data)*0.98);
          maxYAxisLabel = roundToNextTwo(getMax(data)*1.02);
          minXAxisLabel = getMin(data, axis: 'x');
          maxXAxisLabel = getMax(data, axis: 'x');
          if(minYAxisLabel == maxYAxisLabel && maxYAxisLabel == 0){
            maxYAxisLabel =1;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              LineChart(
                LineChartData(
                    minX: minXAxisLabel,
                    maxX: maxXAxisLabel,
                    minY: minYAxisLabel,
                    maxY: maxYAxisLabel,
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
                            interval: 0.25,
                            reservedSize: 40,
                          )
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: bottomTitleWidgets,
                            showTitles: true,
                            interval: 0.25,
                            reservedSize: 40,

                          )
                      ),
                    )
                )
              ),
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
    String axisLabelValue = getAxisLabel(value: value, maxAxisLabel: maxYAxisLabel, minAxisLabel: minYAxisLabel, flattenedData: data, symbol: '', digitsAfterDecimal: 0);
    return Text(axisLabelValue, style: getStyle(), textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    double factor = 0.5;
    int digits = 1;
    Widget text;
    if(maxXAxisLabel > 4){
      factor = 1;
      digits = 0;
    } else {
      factor = 0.5;
      digits = 1;
    }


    if(value % factor == 0){
      text = Text(value.toStringAsFixed(digits),style: style,);
    } else {
      text = Text('');
    }
    // String axisLabelValue = getAxisLabel(value: value, maxAxisLabel: maxXAxisLabel, minAxisLabel: minXAxisLabel, flattenedData: data, symbol: "", digitsAfterDecimal: 2, round: false);
    // text = Text(axisLabelValue, style: style,);

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
