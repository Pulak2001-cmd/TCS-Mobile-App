
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:scidart/numdart.dart';

class PhTrendTLineChartWidget extends StatefulWidget {
  PotatoData selectedVariety;
  double currentRS;
  double T;

  PhTrendTLineChartWidget({Key? key,required this.selectedVariety, required this.currentRS, required this.T }) : super(key: key);

  @override
  State<PhTrendTLineChartWidget> createState() => _PhTrendTLineChartWidgetState();
}

class _PhTrendTLineChartWidgetState extends State<PhTrendTLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 20);
  List<List<double?>> pHList = [[],[],[],[],[],[]];

  Future<List<List<FlSpot>>> futureLineChartData(Array timeVec, List<List<double?>> pHList) async {
    pHList = [[],[],[],[],[],[]];
    List<List<FlSpot>> lineChartData = [[],[],[],[],[],[]];
    for(int i =0 ; i < 6; i+=1) {
      List<double?> pH = pHList[i];
      for (var time in timeVec) {
        var dataPoint = double.parse((await widget.selectedVariety.calculate_ph(time, (i*5 + 5.0), widget.currentRS)).toStringAsFixed(2));
        pH.add(dataPoint);
      }
    }

    for(int i =0 ; i< 6; i++) {
      for (var j = 0; j < pHList[i].length; j++) {
        lineChartData[i].add(FlSpot(timeVec[j], pHList[i][j] ?? 0.0));
      }
    }
    return lineChartData;
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
      future: futureLineChartData(timeVec, pHList),
      builder: (context,snapshot){
        if(snapshot.hasData){
          var data = snapshot.data as List<List<FlSpot>>;
          return LineChart(
              LineChartData(
                  minX:0,
                  maxX: 100,
                  // minY: roundToPrevTens(data[0][0].y) ,
                  // maxY: roundToNextTens(data[0][19].y) ,
                  minY: 0 ,
                  maxY: 14 ,
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
                      spots: data[0] ,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey[200]!,
                          Colors.blueGrey[500]!,
                        ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[1],
                      isCurved: true,
                      gradient: LinearGradient(colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[2] ,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple[200]!,
                          Colors.purple[500]!,
                        ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[3],
                      isCurved: true,
                      gradient: LinearGradient(colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[4] ,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[200]!,
                          Colors.red[500]!,
                        ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data[5],
                      isCurved: true,
                      gradient: LinearGradient(colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                      ),
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Colors.blueGrey[200]!,
                      //       Colors.blueGrey[500]!,
                      //     ].map((color) => color.withOpacity(0.3)).toList(),
                      //   ),
                      // ),
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
                          interval: 1,
                          reservedSize: 40,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          getTitlesWidget: bottomTitleWidgets,
                          showTitles: true,
                          interval: 1,
                          reservedSize: 25,
                        )
                    ),
                  )
              )
          );
        }
        else if (snapshot.hasError){
          print(snapshot.error);
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
    if(value.toInt() % 2 == 0) {
      text = '${value.toStringAsFixed(0)}';
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
