import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class CurrentConditionsScreen extends StatefulWidget {
  const CurrentConditionsScreen({Key? key}) : super(key: key);

  @override
  State<CurrentConditionsScreen> createState() => _CurrentConditionsScreenState();
}

class _CurrentConditionsScreenState extends State<CurrentConditionsScreen> {

  void getData() async{
    http.Response response = await http.get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
    print(response.body);
  }

  //Working stream
  Stream<List<User>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()) ;
  }

  //Utility function to calcualte time in days between 2 given dates
  double calculateTimeDifference(DateTime currentDate, DateTime startDate){
    return double.parse((currentDate.difference(startDate).inHours/24).toStringAsFixed(2));
  }

  //index for Carousel
  int activeIndex0 = 0;
  int temperature = 25;
  double relativeHumidity =97;
  double ethyleneConc = 448;
  double CO2Conc = 400;
  double shelfLife = 22.4;
  double weight = 966;
  DateTime startDate = DateTime.now().subtract(const Duration(hours: 40));
  DateTime currentDate = DateTime.now();
  double initialWeight = 999;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        HexColor('#FF5F6D'),
                        HexColor('#FFC371'),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                                child: Text(
                                  'Storage Conditions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ),
                          ),
                      ),
                      Expanded(
                        child: StreamBuilder<List<User>>(
                          stream: readUsers(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              final users = snapshot.data as List<User>;

                              User user = users[0];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildText('Temperature: ${user.temperature} °C'),
                                  buildText('Relative Humidity: ${user.relativeHumidity} %'),
                                  buildText('Ethylene Conc: ${user.ethyleneConc}ppm'),
                                  buildText('CO2 Conc: ${user.co2Conc}ppm'),
                                ],
                              );
                            } else if(snapshot.hasError){
                              return Text('Something went wrong');
                            } else {
                              return Center(child: CircularProgressIndicator(),);
                            }
                          },
                        )
                      ),


                    ],
                  )
                ),
              ),
              SizedBox(height: 16,),
              Expanded(
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          HexColor('#11998e'),
                          HexColor('#38ef7d'),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Quality Parameters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<List<User>>(
                            stream: readUsers(),
                            builder: (context, snapshot) {
                            if(snapshot.hasData){
                              final users = snapshot.data as List<User>;

                              User user = users[0];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildTextAlert('Lots Unhealthy'),
                                  buildText('Shelf Life: ${PotatoData.calculateRemainingShelflife(
                                      PotatoData.calculateCurrentWeightlossPercentage(),
                                      PotatoData.getTranspirationRate(user.temperature, user.relativeHumidity)
                                      ).toStringAsFixed(2)} days'
                                  ),
                                  buildText('Weight: ${PotatoData.getWeightloss(
                                      user.initialWeight, 
                                      PotatoData.getTranspirationRate(user.temperature, user.relativeHumidity),
                                      calculateTimeDifference(currentDate, user.startDate!)
                                      ).toStringAsFixed(2)} Kgs'
                                  ),
                                ],
                              );
                            } else if(snapshot.hasError){
                              return Text('Something went wrong');
                            } else {
                              return Center(child: CircularProgressIndicator(),);
                            }
                          },
                  ),
                        ),
                      ],
                    ),
                ),
              ),
              SizedBox(height: 16,),
              Expanded(
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          HexColor('#2193b0'),
                          HexColor('#6dd5ed'),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Storage History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: StreamBuilder<List<User>>(
                              stream: readUsers(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  final users = snapshot.data as List<User>;

                                  User user = users[0];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildText('Start Date: ${DateFormat('dd-MM-yyyy').format(user.startDate!)}'),
                                      buildText('Current Date: ${DateFormat('dd-MM-yyyy').format(currentDate)}'),
                                      buildText('Total Days: ${calculateTimeDifference(currentDate, user.startDate!)}'),
                                      buildText('Initial weight: ${user.initialWeight} kgs'),
                                    ],
                                  );
                                } else if(snapshot.hasError){
                                  return Text('Something went wrong');
                                } else {
                                  return Center(child: CircularProgressIndicator(),);
                                }
                              },
                            ),
                        ),


                      ],
                    )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget buildText(String text){
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    );
  }

  Widget buildTextAlert(String text){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          Icon(FontAwesomeIcons.triangleExclamation,color: HexColor('#FF5F6D'),),
          SizedBox(
            width: 16,
          ),
          Text(
            text,
            style: TextStyle(
              color: HexColor('#FF5F6D'),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
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
