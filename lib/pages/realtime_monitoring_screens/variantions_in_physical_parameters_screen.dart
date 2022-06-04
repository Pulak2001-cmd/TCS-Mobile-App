import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_physical_parameters/co2_conc_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_physical_parameters/ethylene_conc_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_physical_parameters/temperature_line_chart.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_physical_parameters/relative_humidity_line_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class VariationsInPhysicalParametersScreen extends StatefulWidget {
  const VariationsInPhysicalParametersScreen({Key? key}) : super(key: key);

  @override
  State<VariationsInPhysicalParametersScreen> createState() => _VariationsInPhysicalParametersScreenState();
}

class _VariationsInPhysicalParametersScreenState extends State<VariationsInPhysicalParametersScreen> {



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
                child: Text('Variations in storage conditions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize:20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: SingleChildScrollView(
                  child: Column(children:[
                    Divider(),
                    Text(
                        'Temperature',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                    ),
                    buildGraph(LineChartWidget()),
                    Text(
                      'Relative Humidity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(RelativeHumidityLineChartWidget()),
                    Text(
                      'Ethylene Conc.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(EthyleneConcLineChartWidget()),
                    Text(
                      'CO2 Conc.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(CO2ConcLineChartWidget()),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildGraph(Widget lineChartWidget) {
    return Container(
      // clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(0,0,0,0),
      padding: EdgeInsets.fromLTRB(0,16,16,16),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      width: double.infinity,
      height: 250,
      child: lineChartWidget,

    );
  }

  Widget buildIndicator(int activeIndex, int count) => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: count,
    effect:  ExpandingDotsEffect(
      dotHeight: 8,
      dotWidth: 8,
      dotColor:  Colors.blueGrey.shade100,
      activeDotColor:  Colors.blueGrey.shade200,
    ),
  );
}
