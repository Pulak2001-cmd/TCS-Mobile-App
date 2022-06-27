import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../common/predictied_line_chart_future.dart';
import '../../../../common/utility_functions.dart';

class PredictionLineChartWidget extends StatefulWidget {
  final String parameter;
  final int digitsAfterDecimal;
  const PredictionLineChartWidget({Key? key, required this.parameter, required this.digitsAfterDecimal}) : super(key: key);

  @override
  State<PredictionLineChartWidget> createState() => _PredictionLineChartWidgetState();
}

class _PredictionLineChartWidgetState extends State<PredictionLineChartWidget> {
  late double maxYAxisLabel;
  late double minYAxisLabel;
  late double maxXAxisLabel;
  late double minXAxisLabel;
  late List<FlSpot> flattenedData;
  final DatabaseReference dataRef =
  FirebaseDatabase.instance.ref().child('dummy-data-2');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJSON(dataRef, widget.parameter, noOfDigitsAfterDecimal: 3),
        builder: (context,snapshot) {
          if(snapshot.hasData) {

            //storing snapshot object as List<FlSpot>
            List<List<FlSpot>> data = snapshot.data as List<List<FlSpot>>;
            flattenedData = data.expand((element) => element).toList();
            minYAxisLabel = roundToPrevTwo(getMin(flattenedData)*0.98);
            maxYAxisLabel = roundToNextTwo(getMax(flattenedData)*1.02);
            minXAxisLabel = getMin(flattenedData, axis: 'x');
            maxXAxisLabel = getMax(flattenedData, axis: 'x');
            if(minYAxisLabel == maxYAxisLabel && maxYAxisLabel == 0){
              maxYAxisLabel =1;
            }

            return LineChart(
                LineChartData(
                    minX: minXAxisLabel,
                    maxX: maxXAxisLabel,
                    minY: minYAxisLabel,
                    maxY: maxYAxisLabel,
                    gridData: FlGridData(
                      show: false,
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
                        isCurved: false,
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
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                  radius: 2,
                                  color: Colors.redAccent.withOpacity(0.5),
                                  strokeColor: Colors.transparent
                              ),
                        ),
                      ),
                      LineChartBarData(
                        spots: data[1],
                        isCurved: false,
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow[200]!,
                            Colors.yellow[500]!,
                          ],
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow[200]!,
                              Colors.yellow[500]!,
                            ].map((color) => color.withOpacity(0.3)).toList(),
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                  radius: 2,
                                  color: Colors.yellow.withOpacity(0.5),
                                  strokeColor: Colors.transparent
                              ),

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
                            interval: 2.5,
                            reservedSize: 30,
                          )
                      ),
                    )
                ));
          }
          else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Something went wrong");
          }
          else
            return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String axisLabelValue = getAxisLabel(value: value, maxAxisLabel: maxYAxisLabel, minAxisLabel: minYAxisLabel, flattenedData: flattenedData, symbol: '', digitsAfterDecimal: widget.digitsAfterDecimal);
    return Text(axisLabelValue, style: getStyle(), textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    String axisLabelValue = getAxisLabel(value: value, maxAxisLabel: maxXAxisLabel, minAxisLabel: minXAxisLabel, flattenedData: flattenedData, axis: 'x');
    text = Text(axisLabelValue, style: style,);

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
