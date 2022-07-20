import 'package:flutter/material.dart';

class UselessProvider with ChangeNotifier{
  bool isLotsHealthy = true;

  void setIsLotsHealthy( bool value){
    this.isLotsHealthy = value;
    notifyListeners();
  }
}