import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/DHT22_sensor_data_model.dart';

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

double roundToPrevTens(double length){
  double temp = double.parse((length/10).truncate().toString())*10;
  return temp;
}

double roundToNextTens(double length){
  double temp = double.parse((length/10).truncate().toString())*10 + 10;
  return temp;
}

double roundToPrevTwo(double value){
  double result = value.floorToDouble();
  return result%2 == 0 ? result : result-1;
}

double roundToNextTwo(double value){
  double result = value.ceilToDouble();
  return result%2 == 0 ? result : result+1;
}

double axisLabelsInterval(List<FlSpot> flattenedData){
  double result = double.parse(((roundToNextTwo(getMax(flattenedData)*1.02) - roundToPrevTwo(getMin(flattenedData)*0.98))/4).toStringAsFixed(1));
  return result == 0 ? 0.25 : result;
}

String getAxisLabel({required double value, required double maxAxisLabel, required double minAxisLabel, required List<FlSpot> flattenedData, String symbol = '%', int digitsAfterDecimal = 1 , String axis = 'y'}){
  String axisLabel ='';
  if(axis == 'y'){
    if(value == maxAxisLabel || value == minAxisLabel){
      axisLabel = '${value.toStringAsFixed(digitsAfterDecimal)} $symbol';
    } else {
      for(int i =1; i<4; i++){
        if(value.compareTo(minAxisLabel + axisLabelsInterval(flattenedData)*i) == 0){
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

TextStyle getStyle() {
  const style = TextStyle(
    color: Color(0xff75729e),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return style;
}

List<Map<String, double>> calculateAvgTemperatureAndHumidityByHours(List<DHT22SensorData> sensorData ,{double hours =24}){
  List<Map<String, double>> avgTemperatureAndHumidityByHoursMaps = [];
  Map<String, double> tempMap = {};
  int noOfPoints = 0;
  double index = 0;
  DateTime prevTimestamp = sensorData.first.timestamp;
  double avgTemperature = sensorData.first.temperatureReading;
  double avgHumidity = sensorData.first.humidityReading;
  Duration timeDifference = sensorData.last.timestamp.difference(sensorData.first.timestamp);
  Iterable<DHT22SensorData> filteredData = [];
  tempMap['index'] = index;
  tempMap['avgT'] = double.parse(avgTemperature.toStringAsFixed(1));
  tempMap['avgRH'] = double.parse(avgHumidity.toStringAsFixed(1));
  avgTemperatureAndHumidityByHoursMaps.add(tempMap);
  for( int j =0; j< timeDifference.inSeconds/(hours*3600); j = j+1){
    filteredData = sensorData.where((element) => (element.timestamp.difference(prevTimestamp).inSeconds/3600 <= hours) && (element.timestamp.difference(prevTimestamp).inSeconds >= 0));
    filteredData.toList().asMap().forEach((i,dataPoint) {
      avgTemperature = avgTemperature*noOfPoints + dataPoint.temperatureReading;
      avgTemperature = avgTemperature/ (noOfPoints+1);
      avgHumidity = avgHumidity*noOfPoints + dataPoint.humidityReading;
      avgHumidity = avgHumidity/ (noOfPoints+1);
      noOfPoints++;
    });
    noOfPoints = 0;
    index = (index + hours);
    tempMap = {};
    tempMap['index'] = index/24;
    tempMap['avgT'] = double.parse(avgTemperature.toStringAsFixed(1));
    tempMap['avgRH'] = double.parse(avgHumidity.toStringAsFixed(1));
    avgTemperatureAndHumidityByHoursMaps.add(tempMap);
    avgTemperature = -1000;
    avgHumidity = -1000;
    prevTimestamp = prevTimestamp.add(Duration(seconds: (hours * 3600).toInt()));
  }
  return avgTemperatureAndHumidityByHoursMaps;
}


//Unused functions created for a previous version
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


