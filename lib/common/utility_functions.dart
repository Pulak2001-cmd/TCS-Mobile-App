///////////////////////////////////////////////////////////////////////
///////////////////// Custom Utility functions ////////////////////////
///////////////////////////////////////////////////////////////////////

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/DHT22_sensor_data_model.dart';

/// function to get the minimum value from a list of FlSpots for the provided axis
double getMin(List<FlSpot> data, {String axis = 'y'}) {
  if(axis == 'y'){
    double min = data.first.y;
    for (var point in data) {
      if (point.y < min) {
        min = point.y;
      } else {
        continue;
      }
    }
    return min;
  } else {
    double min = data.first.x;
    for (var point in data) {
      if (point.x < min) {
        min = point.x;
      } else {
        continue;
      }
    }
    return min;
  }

}

/// function to get the maximum value from a list of FlSpots for the provided axis
double getMax(List<FlSpot> data,{String axis = 'y'}) {
  if(axis == 'y'){
    double max = data.first.y;
    for (var point in data) {
      if (point.y > max) {
        max = point.y;
      } else {
        continue;
      }
    }
    return max;
  } else {
    double max = data.first.x;
    for (var point in data) {
      if (point.x > max) {
        max = point.x;
      } else {
        continue;
      }
    }
    return max;
  }

}

/// function that rounds the given value to the previous tens
double roundToPrevTens(double number){
  double temp = double.parse((number/10).truncate().toString())*10;
  return temp;
}

/// function that rounds the given value to the next tens
double roundToNextTens(double length){
  double temp = double.parse((length/10).truncate().toString())*10 + 10;
  return temp;
}

/// function that rounds the given value to the previous even number
double roundToPrevTwo(double value){
  double result = value.floorToDouble();
  return result%2 == 0 ? result : result-1;
}

/// function that rounds the given value to the next even number
double roundToNextTwo(double value){
  double result = value.ceilToDouble();
  return result%2 == 0 ? result : result+1;
}

/// function that provides the axis interval value for the LineChart widgets
double axisLabelsInterval(List<FlSpot> flattenedData, {bool round = true /* rounds the min and max axis label values to even numbers*/}){
  double result = round ?  double.parse(((roundToNextTwo(getMax(flattenedData)*1.02) - roundToPrevTwo(getMin(flattenedData)*0.98))/4).toStringAsFixed(1)): double.parse(((getMax(flattenedData) - getMin(flattenedData))/4).toStringAsFixed(1));
  return result == 0 ? 0.25 : result; // if the axis interval comes out to be 0 then we provide a default value of 0.25
}

/// function that provides the axis labels for the LineChart widgets
String getAxisLabel({required double value, required double maxAxisLabel, required double minAxisLabel, required List<FlSpot> flattenedData, String symbol = '%' /*symbol to be added at the end of the axis labels*/, int digitsAfterDecimal = 1 , String axis = 'y', bool round = true}){
  String axisLabel ='';
  if(axis == 'y'){
    if(value == maxAxisLabel || value == minAxisLabel){
      axisLabel = '${value.toStringAsFixed(digitsAfterDecimal)} $symbol';
    } else {
      for(int i =1; i<4; i++){
        if(value.compareTo(minAxisLabel + axisLabelsInterval(flattenedData, round: round)*i) == 0){
          axisLabel = '${value.toStringAsFixed(digitsAfterDecimal)} $symbol';
        }
      }
    }
  } else {
    if(maxAxisLabel < 15){
      if (value % 2.5 == 0){
        axisLabel = value.toStringAsFixed(1);
      }
    } else {
      if(value % 5 == 0){
        axisLabel = value.toStringAsFixed(0);
      }
    }
  }
  return axisLabel;
}

/// Text style
TextStyle getStyle() {
  const style = TextStyle(
    color: Color(0xff75729e),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return style;
}

/// Function that provides time-average temperature, humidity, ethylene conc., and CO2 conc from the provided sensor data list. Time can be provided for which the average is to be calculated
/// the function name is a misnomer as it also provides ethylene and CO2 conc.
List<Map<String, double>> calculateAvgTemperatureAndHumidityByHours(List<DHT22SensorData> sensorData ,{double hours =24}){
  List<Map<String, double>> avgTemperatureAndHumidityByHoursMaps = []; // the List that will be returned from the function
  Map<String, double> tempMap = {}; // the tempMap will be added to the above list after getting average readings
  int noOfPoints = 0;
  double index = 0;
  DateTime prevTimestamp = sensorData.first.timestamp; // reading the first timestamp of the sensor readings, this will be used as the starting time from which the average will be calculated for the provided time interval
  double avgTemperature = sensorData.first.temperatureReading; // initialized avgTemperature to the first temperature reading
  double avgHumidity = sensorData.first.humidityReading;// initialized avgHumidity to the first humidity reading
  double? avgEthyleneConc = sensorData.first.ethyleneConcReading;// initialized avgEthyleneConc to the first EthyleneConc reading
  double? avgCO2Conc = sensorData.first.co2ConcReading;// initialized avgCO2Conc to the first CO2Conc reading
  Duration timeDifference = sensorData.last.timestamp.difference(sensorData.first.timestamp); // calculating the time difference between the first and the last reading, to be used to run the for loop
  Iterable<DHT22SensorData> filteredData = [];

  /// initializing tempMap
  /// tempMap contains 5 items
  tempMap['index'] = index;
  tempMap['avgT'] = double.parse(avgTemperature.toStringAsFixed(1));
  tempMap['avgRH'] = double.parse(avgHumidity.toStringAsFixed(1));
  tempMap['avgEC'] = double.parse(avgEthyleneConc?.toStringAsFixed(1) ?? '0');
  tempMap['avgCC'] = double.parse(avgCO2Conc?.toStringAsFixed(1) ?? '0');

  /// adding the tempMap to the list
  avgTemperatureAndHumidityByHoursMaps.add(tempMap);

  /// average values are calculated for the provided 'hours' using the following loop
  for( int j =0; j< timeDifference.inSeconds/(hours*3600); j = j+1){
    // filtering the readings by the timestamps, for hours = 24 the readings are filtered so that all readings for the first 24hrs are used to calculate average values, then the readings for next 24hrs are used to generate next average value and so on
    filteredData = sensorData.where((element) => (element.timestamp.difference(prevTimestamp).inSeconds/3600 <= hours) && (element.timestamp.difference(prevTimestamp).inSeconds >= 0));
    filteredData.toList().asMap().forEach((i,dataPoint) {
      /// calculating avgTemperature
      avgTemperature = avgTemperature*noOfPoints + dataPoint.temperatureReading;
      avgTemperature = avgTemperature/ (noOfPoints+1);
      /// calculating avgHumidity
      avgHumidity = avgHumidity*noOfPoints + dataPoint.humidityReading;
      avgHumidity = avgHumidity/ (noOfPoints+1);
      /// calculating avgEthyleneConc
      avgEthyleneConc = avgEthyleneConc == null ? 0: avgEthyleneConc!*noOfPoints + (dataPoint.ethyleneConcReading ?? 0); // checking if avgEthyleneConc value exists the the sensor readings, for some readings ethylene conc is not provided and we get a null value
      avgEthyleneConc = avgEthyleneConc! / (noOfPoints+1);
      /// calculating avgCO2Conc
      avgCO2Conc = avgCO2Conc == null ? 0:  avgCO2Conc! * noOfPoints + (dataPoint.co2ConcReading ?? 0 );
      avgCO2Conc = avgCO2Conc!/ (noOfPoints+1);
      noOfPoints++;
    });
    noOfPoints = 0;
    index = (index + hours);
    /// resetting tempMap to null
    tempMap = {};
    /// adding average value to tempMap
    tempMap['index'] = index/24;
    tempMap['avgT'] = double.parse(avgTemperature.toStringAsFixed(1));
    tempMap['avgRH'] = double.parse(avgHumidity.toStringAsFixed(1));
    tempMap['avgEC'] = double.parse(avgEthyleneConc?.toStringAsFixed(1) ?? '0');
    tempMap['avgCC'] = double.parse(avgCO2Conc?.toStringAsFixed(1) ?? '0');
    /// adding the tempMap to the list
    avgTemperatureAndHumidityByHoursMaps.add(tempMap);
    /// resetting avg value to -1000, this is done so that if there are no readings for a time duration we can filter out and ignore the readings
    avgTemperature = -1000;
    avgHumidity = -1000;
    avgEthyleneConc = -1000;
    avgCO2Conc = -1000;

    /// incrementing the timestamp to next duration
    prevTimestamp = prevTimestamp.add(Duration(seconds: (hours * 3600).toInt()));
  }
  return avgTemperatureAndHumidityByHoursMaps;
}


/// Unused function created for a previous version
/// provides the average temperature reading from the provided list of DHT22SensorData
List<double> avgTemperatureOfDay(List<DHT22SensorData> sensorData){
  List<double> avgTemperatureByDayList = [];
  int noOfPoints = 0;
  int prevDay = sensorData.first.timestamp.day;
  double avgTemperature = sensorData.first.temperatureReading;
  sensorData.asMap().forEach((i,dataPoint) {
    if(dataPoint.timestamp.day != prevDay){
      noOfPoints = 0;
      avgTemperatureByDayList.add(double.parse(avgTemperature.toStringAsFixed(1)));
      avgTemperature = 0;
      prevDay = dataPoint.timestamp.day;
    }
    avgTemperature = avgTemperature*noOfPoints + dataPoint.temperatureReading;
    avgTemperature = avgTemperature/ (noOfPoints+1);
    noOfPoints++;
  });
  avgTemperatureByDayList.add(double.parse(avgTemperature.toStringAsFixed(1)));
  return avgTemperatureByDayList;
}

/// Unused function created for a previous version
/// /// provides the average humidity reading from the provided list of DHT22SensorData
List<double> avgHumidityOfDay(List<DHT22SensorData> sensorData){
  List<double> avgHumidityOfDayList = [];
  int noOfPoints = 0;
  int prevDay = sensorData.first.timestamp.day;
  double avgHumidity = sensorData.first.humidityReading;
  sensorData.asMap().forEach((i,dataPoint) {
    if(dataPoint.timestamp.day != prevDay){
      noOfPoints = 0;
      avgHumidityOfDayList.add(double.parse(avgHumidity.toStringAsFixed(1)));
      avgHumidity = 0;
      prevDay = dataPoint.timestamp.day;
    }
    avgHumidity = avgHumidity*noOfPoints + dataPoint.humidityReading;
    avgHumidity = avgHumidity/ (noOfPoints+1);
    noOfPoints++;
  });
  avgHumidityOfDayList.add(double.parse(avgHumidity.toStringAsFixed(1)));
  return avgHumidityOfDayList;
}


