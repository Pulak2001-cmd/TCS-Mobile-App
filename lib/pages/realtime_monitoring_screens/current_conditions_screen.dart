import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/providers/alert_provider.dart';
import 'package:flutter_login_ui/providers/current_dashboard_provider.dart';
import 'package:flutter_login_ui/providers/crop_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
// import '../../providers/delete_this_useless_provider.dart';
import 'dart:async';

import '../../providers/quality_of_lots_hardcoded_provider.dart';

class CurrentConditionsScreen extends StatefulWidget {
  const CurrentConditionsScreen({Key? key}) : super(key: key);

  @override
  State<CurrentConditionsScreen> createState() => _CurrentConditionsScreenState();
}

class _CurrentConditionsScreenState extends State<CurrentConditionsScreen> {

  String timestamp = '';
  Map<dynamic,dynamic> latestSensorReading = {};
  int? epochTimestamp;
  StreamSubscription<DatabaseEvent>? sensorDataSubscription;


  void getLatestTimestamp(DatabaseReference dataRef) {
    int latestTimestamp = 0;
     sensorDataSubscription = dataRef.onValue.listen((event) {
      Map<dynamic,dynamic> dataPoints = event.snapshot.value as Map<dynamic,dynamic>;
      dataPoints.forEach((key, value) {
        if(latestTimestamp < double.parse(key)){
          latestTimestamp = double.parse(key).toInt();
        }
      });
      setState((){
        epochTimestamp = latestTimestamp;
        timestamp = DateFormat('d MMM, yy hh:mm aaa').format(DateTime.fromMillisecondsSinceEpoch(latestTimestamp*1000));
        latestSensorReading = dataPoints[latestTimestamp.toString()];
      });
    });

  }

  //Working stream
  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
  }

  //Utility function to calculate time in days between 2 given dates
  double calculateTimeDifference(DateTime currentDate, DateTime startDate){
    return double.parse((currentDate.difference(startDate).inHours/24).toStringAsFixed(2));
  }

  Future toggleDashboard(double dashboard, DatabaseReference dataRef) async{
    sensorDataSubscription?.cancel();
    Provider.of<DashboardProvider>(context, listen: false).setDashboard(dashboard);
    setState((){
      getLatestTimestamp(dataRef);
    });
  }

  //index for Carousel
  int activeIndex0 = 0;
  Color textColor = Colors.white;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getLatestTimestamp(FirebaseDatabase.instance.ref().child('test'));
  }
  @override
  void dispose() {
    sensorDataSubscription?.cancel();
    print('Current conditions disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dataRef = Provider.of<DashboardProvider>(context).dataRef;
    double currentDashboard = Provider.of<DashboardProvider>(context).currentDashboard;

    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,),
          child: Column(
            children: [
              Row(
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
                        onPressed: () async {
                          await toggleDashboard(1, dataRef);
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
                        onPressed: () async {
                          await toggleDashboard(2, dataRef);
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
              SizedBox(height: 8,),
              StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Text('Last data on: $timestamp', style: TextStyle(color: Colors.white70),);
                }
              ),
              SizedBox(height: 8,),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ),
                          ),
                      ),
                      Expanded(
                          child: StreamBuilder<List<double>>(
                            stream: null,
                            builder: (context, snapshot) {
                                /// checking the latest sensor readings for alerts
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Provider.of<AlertProvider>(context,listen: false).checkForAlerts(context, latestSensorReading);
                                });
                                double temperatureReading = latestSensorReading['temperature'].runtimeType == int ? latestSensorReading['temperature'].toDouble() : latestSensorReading['temperature'] ?? 0;
                                double humidityReading = latestSensorReading['humidity'].runtimeType == int ? latestSensorReading['humidity'].toDouble() : latestSensorReading['humidity'] ?? 0;
                                double ethyleneConcReading = latestSensorReading['etheleneConc'].runtimeType == int ? latestSensorReading['etheleneConc'].toDouble() : latestSensorReading['etheleneConc'] ?? 0;
                                double co2ConcReading = latestSensorReading['CO2Conc'].runtimeType == int ? latestSensorReading['CO2Conc'].toDouble() : latestSensorReading['CO2Conc'] ?? 0;


                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildText('Temperature: ${temperatureReading.toStringAsFixed(1)} °C') ,
                                    buildText('Relative Humidity: ${humidityReading.toStringAsFixed(1)} %') ,
                                    buildText('Ethylene Conc: ${ethyleneConcReading.toStringAsFixed(1)} ppm') ,
                                    buildText('CO2 Conc: ${co2ConcReading.toStringAsFixed(1)} ppm') ,
                                  ],
                                );
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<List<UserModel>>(
                            stream: readUsers(),
                            builder: (context, snapshot) {
                            if(snapshot.hasData){
                              final users = snapshot.data as List<UserModel>;
                              UserModel? user;
                              /// TODO: This is hardcoded, needs to be updated
                              if (users.length > 0){
                                user = users.firstWhere((user) => user.email == 'aryanpandey048@gmail.com');
                              }
                              double initialWeight = (user?.initialWeight?.toDouble())!;
                              double transpirationRate = PotatoData.getTranspirationRate(latestSensorReading['temperature'] ?? 0, latestSensorReading['humidity'] ?? 0);
                              double time = currentDashboard == 1? calculateTimeDifference(currentDate, user!.startDate!):calculateTimeDifference(currentDate, user!.startDate2!);
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
                                  // (Provider.of<CropListProvider>(context).cropStatusList.length != 0) ?
                                  //   Provider.of<CropListProvider>(context).cropStatusList.last.overallHealthStatus == 'Healthy'? buildTextAlert('Lots Healthy') : buildTextAlert('Lots Unhealthy'):
                                  //     SizedBox(),
                                  Provider.of<UselessProvider>(context).isLotsHealthy ? buildTextAlert('Lots Healthy') : buildTextAlert('Lots Unhealthy'),
                                  buildText('Shelf Life: ${shelfLife.toStringAsFixed(2)} days'),
                                  buildText('Weight: ${currentWeight.toStringAsFixed(2)} Kgs'),
                                ],
                              );
                            } else if(snapshot.hasError){
                              print(snapshot..error);
                              return Text('${snapshot..error}');
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: StreamBuilder<List<UserModel>>(
                              stream: readUsers(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  final users = snapshot.data as List<UserModel>;
                                  /// Create a logic to select the logged in user and remove this hardcoding of users
                                  UserModel user = users[0];
                                  if (users.length > 0){
                                    user = users.firstWhere((user) => user.name == 'Priya Kedia');
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      currentDashboard == 1 ? buildText('Start Date: ${DateFormat('dd-MM-yyyy').format(user.startDate!)}'): buildText('Start Date: ${DateFormat('dd-MM-yyyy').format(user.startDate2!)}'),
                                      buildText('Current Date: ${DateFormat('dd-MM-yyyy').format(currentDate)}'),
                                      currentDashboard == 1 ? buildText('Total Days: ${calculateTimeDifference(currentDate, user.startDate!)}'):buildText('Total Days: ${calculateTimeDifference(currentDate, user.startDate2!)}'),
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

  /// Widget that builds a simple Text() widget with provided string
  Widget buildText(String text){
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
    );
  }

  /// Widget tht builds text alert of 'Lots Unhealthy' or 'Lots healthy' in Quality parameters section
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
}
