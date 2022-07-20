///////////////////////////////////////////////////////////////////////////
////////////////Current dashboard and dataRef provider/////////////////////
///////////////////////////////////////////////////////////////////////////

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier{
  double currentDashboard = 1; /// initialize current dashboard to '1'
  DatabaseReference dataRef = FirebaseDatabase.instance.ref().child('test'); /// initialize reading of sensor data from 'test' document in database i.e ambient conditons


  /// Function to update dashboard
  void setDashboard(double dashboard){
    this.currentDashboard = dashboard;
    this.dataRef = dashboard == 1 ? FirebaseDatabase.instance.ref().child('test'): FirebaseDatabase.instance.ref().child('sensor-2');
    notifyListeners();
  }
}