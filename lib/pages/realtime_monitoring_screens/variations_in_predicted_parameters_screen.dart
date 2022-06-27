import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/test/prediction_line_chat_widget.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/ph_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/reducing_sugar_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/starch_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/total_sugar_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_predicted_parameters/weight_line_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
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

  Future refresh() async{
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Variations in predicted parameters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Column(children:[
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Legend',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GradientText(
                                  'Past predictions',
                                  colors: [
                                    Colors.red[200]!,
                                    Colors.red[500]!,
                                  ],
                                ),
                                SizedBox(width: 16,),
                                GradientText(
                                  'Forecast (10 days)',
                                  colors: [
                                    Colors.yellow[200]!,
                                    Colors.yellow[500]!,
                                  ],
                                ),
                            ],)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text(
                      'Weight (kg)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Weight', digitsAfterDecimal: 0)),
                    Text(
                      'Reducing Sugar (1E-5 %w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Reducing Sugar', digitsAfterDecimal: 1)),
                    Text(
                      'Total Sugar (%w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Total sugar', digitsAfterDecimal: 1)),
                    Text(
                      'pH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'pH', digitsAfterDecimal: 1)),
                    Text(
                      'Starch (%w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Starch', digitsAfterDecimal: 1)),
                  ]),
                ),
              ],
            ),
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
      child: Column(
        children: [
          Expanded(child: Stack(
            children: [
              lineChartWidget,
              // Positioned(
              //     right: 10,
              //     top: 10,
              //     child: Column(
              //       children: [
              //         Text('Legend'),
              //         Text('Predicted data')
              //       ],)
              // )
            ],
          ),),
          Text(
              "           Time (days)",
              style : TextStyle(
                color: Color(0xff75729e),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
          )
        ],
      ),

    );
  }
}
