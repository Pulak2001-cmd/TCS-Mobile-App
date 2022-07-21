import 'package:flutter/material.dart';

/// TODO: we had hardcoded the lot status in the dashboard to show predetermined results, this provider was created for that purpose hence the naming :p
class UselessProvider with ChangeNotifier{
  bool isLotsHealthy = true;

  void setIsLotsHealthy( bool value){
    this.isLotsHealthy = value;
    notifyListeners();
  }
}