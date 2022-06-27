import 'package:flutter/material.dart';

class AlertProvider with ChangeNotifier{
  List<String> _alertList = [];

  int getLength(){
    return _alertList.length;
  }

  void addAlert(String alert){
    if(isAlertAlreadyAdded(alert) == false) {
      _alertList.add(alert);
      notifyListeners();
    }
  }

  String getAlert(index){
    return this._alertList[index];
  }

  void checkForAlerts(BuildContext context, user){
    if(user.temperature! > 50){
      String alert = 'Temperature greater than critical limit!';
      if(isAlertAlreadyAdded(alert) == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if ( user.relativeHumidity! < 10 ){
      String alert = 'Humidity less than critical limit!';
      if(isAlertAlreadyAdded(alert) == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if (user.ethyleneConc! > 430){
      String alert = 'Ethylene conc. greater than critical limit!';
      if(isAlertAlreadyAdded(alert) == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if (user.co2Conc! > 500){
      String alert = 'CO2 conc. greater than critical limit!';
      if(isAlertAlreadyAdded(alert) == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    notifyListeners();
  }

  void removeAt(int index){
    print(_alertList);
    this._alertList.removeAt(index);
    print(_alertList);
    notifyListeners();
  }

  bool isAlertAlreadyAdded(String alert) {
    bool result = false;
    _alertList.forEach((element) {
      if(element == alert) {
        result = true;
      }
    });
    return result;
  }

  SnackBar _buildSnackBar(String alert) => SnackBar(
    content: Text(alert,
      style: TextStyle(
        color: Colors.white70,
      ),),
    backgroundColor: Colors.redAccent,

    duration: Duration(days: 365), //snack bar is display for 1 year or until dismissed
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: (){},
    ),
  );
}