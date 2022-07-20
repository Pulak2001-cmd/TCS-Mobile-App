import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/utility_functions.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:provider/provider.dart';
import 'package:scidart/numdart.dart';

class RSTrendVarietyLineChartWidget extends StatefulWidget {
  final PotatoData selectedVariety;
  final double? currentRS;

  RSTrendVarietyLineChartWidget({Key? key,required this.selectedVariety,this.currentRS}) : super(key: key);

  @override
  State<RSTrendVarietyLineChartWidget> createState() => _RSTrendVarietyLineChartWidgetState();
}

class _RSTrendVarietyLineChartWidgetState extends State<RSTrendVarietyLineChartWidget> {



  Array timeVec = linspace(0, 100, num: 100);
  List<List<double?>> reducingSugarList = [[],[],[],[],[],[]];

  Future<List<List<FlSpot>>> futureLineChartData(Array timeVec, List<List<double?>> reducingSugarList) async {
    List<List<FlSpot>> lineChartData = [[],[],[],[],[],[]];

    for(int i =0 ; i < 6; i++) {
      List<double?> reducingSugar = reducingSugarList[i];
      for (var time in timeVec) {
        /// if currentRS is provided use that value, otherwise use RS value for variety provided. Default value is set to 0.001%
        double? result = await widget.selectedVariety.RS_day(time, (i*2 + 2), widget.currentRS == null ?  PotatoData.rsAvg(variety: widget.selectedVariety.variety! , varietyType: widget.selectedVariety.varietyType!) : widget.currentRS);
        result = double.parse((result?.toStringAsFixed(5))!);

        reducingSugar.add(result);
      }
    }

    for(int i =0 ; i< 6; i++) {
      for (var j = 0; j < timeVec.length; j++)
        lineChartData[i].add(FlSpot(timeVec[j], reducingSugarList[i][j] ?? 0));
    }
    return lineChartData;
  }

  late double maxAxisLabel;
  late double minAxisLabel;
  late List<FlSpot> flattenedData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLineChartData(timeVec, reducingSugarList),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<List<FlSpot>> rawData = snapshot.data as List<List<FlSpot>>;
          /// removing any point with RS value above 0.5% from rawData and making new list data
          List<List<FlSpot>> data = [];
          rawData.forEach((element) {data.add(element.where((element) => element.y <= 0.5).toList());});
          flattenedData = data.expand((element) => element).toList();
          minAxisLabel = roundToPrevTwo(getMin(flattenedData));
          maxAxisLabel = roundToNextTwo(getMax(flattenedData));
          if(minAxisLabel == maxAxisLabel && maxAxisLabel == 0){
            maxAxisLabel =1;
          }
          return LineChart(
              LineChartData(
                  minX:0,
                  maxX: 100,
                  minY: minAxisLabel,
                  maxY: 0.5,
                  // clipData: FlClipData.vertical(),
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
                  extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0.3,
                          color: Colors.red,
                          strokeWidth: 1,
                        )
                      ]
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
                      isCurved: false,
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
                      isCurved: false,
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
                      isCurved: false,
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
                      isCurved: false,
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
                      isCurved: false,
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
                      isCurved: false,
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
                          interval: 0.1,
                          reservedSize: 40,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          getTitlesWidget: bottomTitleWidgets,
                          showTitles: true,
                          interval: 1,
                          reservedSize: 35,
                        )
                    ),
                  )
              )
          );
        } else if (snapshot.hasError){
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
/// Previous dynamic titles
// Widget leftTitleWidgets(double value, TitleMeta meta) {
//   return Text(getAxisLabel(value: value, maxAxisLabel: maxAxisLabel, minAxisLabel: minAxisLabel, flattenedData: flattenedData), style: getStyle(), textAlign: TextAlign.center);
// }
// Widget bottomTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(
//     color: Color(0xff72719b),
//     fontWeight: FontWeight.bold,
//     fontSize: 16,
//   );
//   Widget text;
//   if(value.toInt()%20 == 0) {
//     text = Text('${value.toStringAsFixed(0)}', style: style,);
//   } else {
//     text = Text('');
//   }
//
//   return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
// }

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
