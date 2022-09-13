import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class DynamicDecisionPage extends StatefulWidget {
  const DynamicDecisionPage({Key? key}) : super(key: key);

  @override
  State<DynamicDecisionPage> createState() => _DynamicDecisionPageState();
}

class _DynamicDecisionPageState extends State<DynamicDecisionPage> {
  var rng = Random();
  int val = 60;
  double temp = 25;
  double humidity = 80;
  void initState() {
    super.initState();
    val = rng.nextInt(100);
    print(val);
    getLocation();
  }

  void getLocation() async {
    //if sensor is there temp = Sensor temperature
    // else
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // print(position);
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=Pune&appid=c6c6a3cd9469ef7a7c78e2c5db977a18";

    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> x = jsonDecode(response.body);
    print(x);
    temp = (x["main"]["temp"]) - 273;
    humidity = double.parse(x["main"]["humidity"].toString());
    print(temp);
    print(humidity);
  }

  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Dynamic Decision Making',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<Object>(
                  stream: readUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final users = snapshot.data as List<UserModel>;
                      UserModel? user;
                      if (users.length > 0) {
                        user = users.firstWhere((user) =>
                            user.uid == Provider.of<User?>(context)?.uid);
                      }
                      return Center(
                        child: Table(
                          columnWidths: {
                            0: FractionColumnWidth(0.33),
                            1: FractionColumnWidth(0.33),
                            2: FractionColumnWidth(0.34),
                          },
                          border: TableBorder.all(color: Colors.white70),
                          children: [
                            buildRow([
                              'Storage Condition(°C, %)',
                              //two more rows
                              'Application',
                              'Shelf Life (Days)'
                            ], isHeader: true),

                            buildRow([
                              'Current ($temp , $humidity)',
                              user?.endUse ?? 'Chips',
                              val.toString()
                            ]),
                            // buildRow(['Ambient', 'Domentic Use', '']),
                            buildRow([
                              '',
                              'Domestic Use',
                              rng.nextInt(100).toString()
                            ]),
                            buildRow([
                              'Cold storage II (5, 95%)',
                              'Domestic Use',
                              rng.nextInt(100).toString()
                            ]),
                            buildRow([
                              'Current ($temp , $humidity)',
                              'Animal feed',
                              rng.nextInt(100).toString()
                            ]),
                            buildRow([
                              'Current ($temp , $humidity)',
                              'Fries',
                              rng.nextInt(100).toString()
                            ]),
                            buildRow([
                              'Current ($temp , $humidity)',
                              'Starch',
                              rng.nextInt(100).toString()
                            ]),
                            buildRow([
                              'Current ($temp , $humidity)',
                              'Seeds',
                              rng.nextInt(100).toString()
                            ]),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Something went wrong');
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
      children: cells
          .map((cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      cell,
                      style: TextStyle(
                        fontWeight:
                            isHeader ? FontWeight.bold : FontWeight.normal,
                        color: isHeader ? Colors.white : Colors.white70,
                        fontSize: isHeader ? 20 : 16,
                      ),
                    )),
              ))
          .toList());
}
