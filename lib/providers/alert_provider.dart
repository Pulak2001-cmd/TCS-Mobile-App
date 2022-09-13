////////////////////////////////////////////////////////////////////////////////////////
//////////////// Alert provider with functions to check for alerts /////////////////////
////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

class AlertProvider with ChangeNotifier {
  List<Map<String, dynamic>> _alertList = [];

  /// function to provide length of alert list
  int getLength() {
    return _alertList.length;
  }

  /// function to add alerts to alertList
  void addAlert(Map<String, dynamic> alert) {
    if (isAlertAlreadyAdded(alert['alertString']) == false) {
      _alertList.add(alert);
      notifyListeners();
    }
  }

  /// function that returns a single alert by the index
  Map<String, dynamic> getAlert(index) {
    return this._alertList[index];
  }

  /// Function that checks for alerts in the latestSensorReadings and shows a SnackBar with alerts
  void checkForAlerts(
      BuildContext context, Map<dynamic, dynamic> latestSensorReading) {
    /// TODO: initially null value is passed, so add check for null value
    if (latestSensorReading['temperature']! > 50) {
      Map<String, dynamic> alert = {
        "alertString": 'Temperature greater than critical limit!',
        "timestamp": DateTime.now(),
      };
      if (isAlertAlreadyAdded(alert['alertString']) == false) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if (latestSensorReading['humidity']! < 10) {
      Map<String, dynamic> alert = {
        "alertString": 'Humidity less than critical limit!',
        "timestamp": DateTime.now(),
      };
      if (isAlertAlreadyAdded(alert['alertString']) == false) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if (latestSensorReading['etheleneConc']! > 430) {
      Map<String, dynamic> alert = {
        "alertString": 'Ethylene conc. greater than critical limit!',
        "timestamp": DateTime.now(),
      };
      if (isAlertAlreadyAdded(alert['alertString']) == false) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    if (latestSensorReading['CO2Conc']! > 500) {
      Map<String, dynamic> alert = {
        "alertString": 'CO2 conc. greater than critical limit!',
        "timestamp": DateTime.now(),
      };
      if (isAlertAlreadyAdded(alert['alertString']) == false) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          this.addAlert(alert);
          final snackBar = _buildSnackBar(alert);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
    notifyListeners();
  }

  /// function that removes an alert at the provided index
  void removeAt(int index) {
    print(_alertList);
    this._alertList.removeAt(index);
    print(_alertList);
    notifyListeners();
  }

  /// Utility function that checks if the alert is already added
  /// TODO: rework this function to add alerts again even if the same alert was added earlier, maybe add another alert after a certain amount of time has passed
  bool isAlertAlreadyAdded(String alert) {
    bool result = false;
    _alertList.forEach((element) {
      if (element['alertString'] == alert) {
        result = true;
      }
    });
    return result;
  }

  /// function that builds a SnackBar in the provided context with the alert as the message
  SnackBar _buildSnackBar(Map<String, dynamic> alert) => SnackBar(
        content: Text(
          alert['alertString'],
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.redAccent,

        duration: Duration(
            days: 365), //snack bar is display for 1 year or until dismissed
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
}
