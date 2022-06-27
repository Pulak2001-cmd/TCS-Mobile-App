import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/utility_functions.dart';
import '../../../../models/DHT22_sensor_data_model.dart';


class Test2LineChartWidget extends StatefulWidget {

  Test2LineChartWidget({Key? key}) : super(key: key);

  @override
  State<Test2LineChartWidget> createState() => _Test2LineChartWidgetState();
}

class _Test2LineChartWidgetState extends State<Test2LineChartWidget> {

  final DatabaseReference dataRef =
  FirebaseDatabase.instance.ref().child('test');

  Future<List<FlSpot>> getJSON(DatabaseReference dataRef) async{
    List<DHT22SensorData> sensorData = [];
    List<FlSpot> temperatureLineChartData = [];
    List<FlSpot> humidityLineChartData = [];
    DataSnapshot data = await dataRef.get();
    List<DataSnapshot> dataList = data.children.toList();
    dataList.forEach((reading) {
      DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
      temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
      sensorData.add(temp);
      temperatureLineChartData.add(FlSpot(double.parse(reading.key!), temp.temperatureReading));
      humidityLineChartData.add(FlSpot(double.parse(reading.key!), temp.humidityReading));
    });
    return temperatureLineChartData;

  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getJSON(dataRef),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<FlSpot> data = snapshot.data as List<FlSpot>;
          return LineChart(
              LineChartData(
                  minX:data.first.x,
                  maxX: data.last.x,
                  minY: roundToPrevTwo(getMin(data)),
                  maxY: roundToNextTwo(getMax(data)),
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
                      spots: snapshot.data as List<FlSpot>,
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
                          interval: double.parse(((roundToNextTwo(getMax(data)) - roundToPrevTwo(getMin(data)))/4).toStringAsFixed(1)),
                          reservedSize: 40,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          getTitlesWidget: bottomTitleWidgets,
                          showTitles: true,
                          interval: 15,
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
      text = Text('${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch( value.toInt() * 1000))}', style: style,);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
