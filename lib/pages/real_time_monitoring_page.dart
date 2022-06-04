


import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/quality_of_lots_screen.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/variantions_in_physical_parameters_screen.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/current_conditions_screen.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/variations_in_predicted_parameters_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class RealTimeMonitoringPage extends StatefulWidget {
  const RealTimeMonitoringPage({Key? key}) : super(key: key);

  @override
  State<RealTimeMonitoringPage> createState() => _RealTimeMonitoringPageState();
}

class _RealTimeMonitoringPageState extends State<RealTimeMonitoringPage> {

  //index for bottom navigation
  int currentIndex = 0;
  final screens = [
    //Screen 1
    CurrentConditionsScreen(),
    //Screen 2
    VariationsInPhysicalParametersScreen(),
    //Screen 3
    VariationsInPredictedParametersScreen(),
    //Screen 4
    QualityOfLotsScreen(),
  ];

  //index for Carousel
  int activeIndex0 = 0;
  int activeIndex1 = 0;
  int activeIndex2 = 0;
  final urls = [
    'https://images.edrawmax.com/images/knowledge/line-graph-1-what-is.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Pushkin_population_history.svg/1200px-Pushkin_population_history.svg.png',
    'https://images.edrawmax.com/images/knowledge/line-graph-1-what-is.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Pushkin_population_history.svg/1200px-Pushkin_population_history.svg.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Realtime monitoring',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          onTap: (index) => setState(() {
            currentIndex = index;
          }),
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_chart_rounded),
              label: 'Current data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.aod_rounded),
              label: 'Variations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_to_queue_rounded),
              label: 'Predictions',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.checkToSlot),
              label: 'Quality',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor('#423F46'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Storage Conditions',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),
          ),
          SizedBox(height: 5,),
          Text('Temperature: 17 C',
            style: TextStyle(
                color: Colors.white
            ),),
          SizedBox(height: 5,),
          Text('Relative Humidity: 93 %',
            style: TextStyle(
                color: Colors.white
            ),),
          SizedBox(height: 5,),
          Text('Ethylene conc: 408',
            style: TextStyle(
                color: Colors.white
            ),),
          SizedBox(height: 5,),
          Text('CO2 conc: 400',
            style: TextStyle(
                color: Colors.white
            ),),
        ],
      ),
    );
  }

  Widget buildImage(String image, int index ) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor('#423F46'),
      ),
      width: double.infinity,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color: Colors.blueGrey.shade200,
          ),
        ),
      ),
      // child: Image.network(image,
      // fit: BoxFit.cover,),

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