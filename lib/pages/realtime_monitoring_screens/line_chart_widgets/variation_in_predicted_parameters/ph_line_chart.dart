import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/utility_functions.dart';
import '../../../../common/predicted_line_chart_stream.dart';

class PHLineChartWidget extends StatefulWidget {
  PHLineChartWidget({Key? key}) : super(key: key);
  double maxVal = -double.infinity;

  @override
  State<PHLineChartWidget> createState() => _PHLineChartWidgetState();
}

class _PHLineChartWidgetState extends State<PHLineChartWidget> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: getData(parameter: 'pH', noOfDigitsAfterDecimal: 1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //storing snapshot object as List<FlSpot>
            List<List<FlSpot>> data = snapshot.data as List<List<FlSpot>>;

            widget.maxVal = getMax(data[0])+5;

            return LineChart(LineChartData(
                minX: 0,
                maxX: data[1].last.x,
                minY: getMin([...data[0], ...data[1]]) * 0.9,
                maxY: getMax([...data[0], ...data[1]]) * 1.1,
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
                      show: false,
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
                      show: false,
                    ),
                  )
                ],
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: false,
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: false,
                  )),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    getTitlesWidget: leftTitleWidgets,
                    showTitles: true,
                    interval: double.parse(( ( getMax([...data[0], ...data[1]]) * 1.1 - getMin([...data[0], ...data[1]]) * 0.9) / 4).toStringAsFixed(4)),
                    reservedSize: 40,
                  )),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    getTitlesWidget: bottomTitleWidgets,
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                  )),
                )));
          } else if (snapshot.hasError) {
            print("Error in pH graph is: ");
            print(snapshot.error);
            return Text("Something went wrong");
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value.toInt() % 1 == 0 || value == widget.maxVal) {
      text = value.toStringAsFixed(1);
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
    if (value.toInt() % 5 == 0) {
      text = Text(value.toStringAsFixed(0), style: style);
    } else {
      text = Text('');
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }
}
