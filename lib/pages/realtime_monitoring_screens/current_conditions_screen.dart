import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/providers/alert_provider.dart';
import 'package:flutter_login_ui/providers/temp_crop_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class CurrentConditionsScreen extends StatefulWidget {
  const CurrentConditionsScreen({Key? key}) : super(key: key);

  @override
  State<CurrentConditionsScreen> createState() => _CurrentConditionsScreenState();
}

class _CurrentConditionsScreenState extends State<CurrentConditionsScreen> {

  //Working stream
  Stream<List<User>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()) ;
  }

  //Utility function to calculate time in days between 2 given dates
  double calculateTimeDifference(DateTime currentDate, DateTime startDate){
    return double.parse((currentDate.difference(startDate).inHours/24).toStringAsFixed(2));
  }

  //index for Carousel
  int activeIndex0 = 0;
  Color textColor = Colors.white70;
  DateTime currentDate = DateTime.now();

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
                              //Adding alerts
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Provider.of<AlertProvider>(context,listen: false).checkForAlerts(context, user);
                              });

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildText('Temperature: ${user.temperature} °C', user),
                                  buildText('Relative Humidity: ${user.relativeHumidity} %', user),
                                  buildText('Ethylene Conc: ${user.ethyleneConc}ppm', user),
                                  buildText('CO2 Conc: ${user.co2Conc}ppm', user),
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
                              double initialWeight = (user.initialWeight?.toDouble())!;
                              double transpirationRate = PotatoData.getTranspirationRate(user.temperature, user.relativeHumidity);
                              double time = calculateTimeDifference(currentDate, user.startDate!);
                              double currentWeight = PotatoData.getWeightloss(initialWeight, transpirationRate, time);
                              double currentWeightlossPercentage = PotatoData.calculateCurrentWeightlossPercentage(initialWeight,currentWeight);
                              double shelfLife = PotatoData.calculateRemainingShelflife(
                                  currentWeightlossPercentage,
                                  transpirationRate
                              );
                              shelfLife = shelfLife < 0 ? 0: shelfLife;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  (Provider.of<CropListProvider>(context).cropStatusList.length != 0) ?
                                    Provider.of<CropListProvider>(context).cropStatusList.last.overallHealthStatus == 'Healthy'? buildTextAlert('Lots Healthy') : buildTextAlert('Lots Unhealthy'):
                                      SizedBox(),
                                  buildText('Shelf Life: ${shelfLife.toStringAsFixed(2)} days', user
                                  ),
                                  buildText('Weight: ${currentWeight.toStringAsFixed(2)} Kgs', user
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
                                      buildText('Start Date: ${DateFormat('dd-MM-yyyy').format(user.startDate!)}', user),
                                      buildText('Current Date: ${DateFormat('dd-MM-yyyy').format(currentDate)}', user),
                                      buildText('Total Days: ${calculateTimeDifference(currentDate, user.startDate!)}', user),
                                      buildText('Initial weight: ${user.initialWeight} kgs', user),
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

  Widget buildText(String text, User user){

    // if(user.temperature! > 50){
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => setState((){textColor = Colors.red;}));
    // }
    // if(user.relativeHumidity! < 10 ){
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => setState((){textColor = Colors.red;}));
    // }
    // if(user.ethyleneConc! > 430){
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => setState((){textColor = Colors.red;}));
    // }
    // if(user.co2Conc! > 500){
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => setState((){textColor = Colors.red;}));
    // }
    return Text(
      text,
      style: TextStyle(
        color: textColor,
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
          text == 'Lots Unhealthy' ? Icon(FontAwesomeIcons.triangleExclamation,color: HexColor('#FF5F6D'),) : Icon(FontAwesomeIcons.solidFaceSmile,color: Colors.white,) ,
          SizedBox(
            width: 16,
          ),
          Text(
            text,
            style: TextStyle(
              color: text == 'Lots Unhealthy' ? HexColor('#FF5F6D') : Colors.white,
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
