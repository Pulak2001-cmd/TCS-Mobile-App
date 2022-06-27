import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/utility_functions.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:scidart/numdart.dart';

class TotalSugarTrendTLineChartWidget extends StatefulWidget {
  PotatoData selectedVariety;
  double currentRS;
  double T;

  TotalSugarTrendTLineChartWidget({Key? key,required this.selectedVariety, required this.currentRS, required this.T }) : super(key: key);

  @override
  State<TotalSugarTrendTLineChartWidget> createState() => _TotalSugarTrendTLineChartWidgetState();
}

class _TotalSugarTrendTLineChartWidgetState extends State<TotalSugarTrendTLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 20);
  List<List<double?>> totalSugarList = [[],[],[],[],[],[]];

  Future<List<List<FlSpot>>> futureLineChartData(Array timeVec, List<List<double?>> totalSugarList) async {
    List<List<FlSpot>> lineChartData = [[],[],[],[],[],[]];

    for(int i =0 ; i < 6; i++) {
      List<double?> totalSugar = totalSugarList[i];
      for (var time in timeVec) {
        var dataPoint = double.parse((await widget.selectedVariety.calculate_tot_sugar(
            time, (i*5 + 5), widget.currentRS)).toStringAsFixed(2));
        totalSugar.add(dataPoint);
      }
    }

    for(int i =0 ; i< 6; i++) {
      for (var j = 0; j < timeVec.length; j++)
        lineChartData[i].add(FlSpot(timeVec[j], totalSugarList[i][j] ?? 0));
    }
    return lineChartData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLineChartData(timeVec, totalSugarList),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<List<FlSpot>> data = snapshot.data as List<List<FlSpot>>;
          List<FlSpot> flattenedData = data.expand((element) => element).toList();
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
                          interval: axisLabelsInterval(flattenedData),
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
