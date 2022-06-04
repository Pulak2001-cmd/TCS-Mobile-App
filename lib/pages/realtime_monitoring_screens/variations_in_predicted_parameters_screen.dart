import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/ph_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/reducing_sugar_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/starch_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/total_sugar_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/weight_line_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VariationsInPredictedParametersScreen extends StatefulWidget {
  const VariationsInPredictedParametersScreen({Key? key}) : super(key: key);

  @override
  State<VariationsInPredictedParametersScreen> createState() => _VariationsInPredictedParametersScreenState();
}

class _VariationsInPredictedParametersScreenState extends State<VariationsInPredictedParametersScreen> {

  int activeIndex1 =0;

  final urls = [
    '1','2','3','4'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Variations in predicted parameters',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Column(children:[
                  Divider(),
                  Text(
                    'Weight (kg)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildGraph(WeightLineChartWidget()),
                  Text(
                    'Reducing Sugar (%w/FW)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildGraph(ReducingSugarLineChartWidget()),
                  Text(
                    'Total Sugar (%w/FW)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildGraph(TotalSugarLineChartWidget()),
                  Text(
                    'pH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildGraph(PHLineChartWidget()),
                  Text(
                    'Starch (%)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildGraph(StarchLineChartWidget()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGraph(Widget lineChartWidget) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(0,0,28,0),
      padding: EdgeInsets.fromLTRB(16,16,16,16),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      width: double.infinity,
      height: 250,
      child: lineChartWidget,

    );
  }
}
