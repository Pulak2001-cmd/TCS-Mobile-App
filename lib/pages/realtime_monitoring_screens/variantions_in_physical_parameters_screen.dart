import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/widgets/physical_parameters_line_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../providers/current_dashboard_provider.dart';
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
  double currentDashboard = 1;

  @override
  Widget build(BuildContext context) {
    DatabaseReference dataRef = Provider.of<DashboardProvider>(context).dataRef;
    double currentDashboard = Provider.of<DashboardProvider>(context).currentDashboard;
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: currentDashboard == 1 ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ) :ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0.0),
                          ),
                          onPressed: (){
                            Provider.of<DashboardProvider>(context, listen: false).setDashboard(1);
                            setState((){});
                          },
                          child: Text(
                            'System 1',
                            style: TextStyle(
                                color: Colors.white70
                            ),)),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: ElevatedButton(
                          style: currentDashboard == 2 ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ) :ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0.0),
                          ),
                          onPressed: (){
                            Provider.of<DashboardProvider>(context, listen: false).setDashboard(2);
                            setState((){});
                          },
                          child: Text(
                            'System 2',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
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
                        'Temperature (°C)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                    ),
                    buildGraph(LineChartWidget(parameter: 'temperature',dataRef: dataRef,)),
                    Text(
                      'Relative Humidity (%)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(LineChartWidget(parameter: 'relative humidity',dataRef: dataRef,)),
                    Text(
                      'Ethylene Conc. (ppm)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(LineChartWidget(parameter: 'ethylene conc',dataRef: dataRef,)),
                    Text(
                      'CO2 Conc. (ppm)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(LineChartWidget(parameter: 'co2 conc',dataRef: dataRef,)),
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
      child: Column(
        children: [
          Expanded(child: lineChartWidget),
          Text(
            "           Time (days)",
            style : TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),

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
