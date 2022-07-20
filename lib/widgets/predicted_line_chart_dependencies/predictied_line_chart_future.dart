import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_login_ui/common/utility_functions.dart';

import '../../models/DHT22_sensor_data_model.dart';
import '../../models/potato_data_model.dart';



Future<List<FlSpot>> populatePastPredictionsLineChartData({required List<Map<String, double>> avgTemperatureByHoursMaps, int noOfDigitsAfterDecimal = 1, required String parameter, required PotatoData potatoData}) async {
  List<FlSpot> pastPredictionsLineChartData = [];
  for(int index =0; index< avgTemperatureByHoursMaps.length; index++){
    if(avgTemperatureByHoursMaps[index]['avgT'] == -1000.0) {
      continue ;
    }
    double T = avgTemperatureByHoursMaps[index]['avgT']!;
    double RH =  avgTemperatureByHoursMaps[index]['avgRH']!;
    double time = avgTemperatureByHoursMaps[index]['index']!;
    double initialWeight = 999;
    double transpirationRate = PotatoData.getTranspirationRate(double.parse(T.toString()), double.parse(RH.toString()));

    ////////////////////////////////////////////////////////////////////////////////////////
    double? predictedData;
    switch(parameter) {
    //Total sugar
      case 'Total sugar':
        predictedData = await PotatoData().calculate_tot_sugar(time, T, RH);
        break;
    //pH
      case 'pH':
        predictedData = await PotatoData().calculate_ph(time, T, RH);
        break;
    //Starch
      case 'Starch':
        predictedData = await PotatoData().calculate_starch(time, T, RH);
        break;
    //Weight
      case 'Weight':
      // "await" not required as no data is read from excel file
        predictedData = PotatoData.getWeightloss(initialWeight, transpirationRate, time);
        break;
    //Reducing sugar
      case 'Reducing Sugar':
        predictedData = await potatoData.RS_day(time, T, PotatoData.rsAvg(variety: potatoData.variety!)) ?? -10;
        // predictedData *= 100000;
        break;
      default:
        print('Error in populatePastPredictionsLineChartData. default case ran.');
        break;
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    predictedData = double.parse((predictedData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
    pastPredictionsLineChartData.add(FlSpot(time, predictedData));
  }
  return pastPredictionsLineChartData;
}

Future<List<List<FlSpot>>> getJSON(DatabaseReference dataRef, String parameter, {int noOfDigitsAfterDecimal = 1, String variety = 'Saturna'}) async{

  PotatoData potatoData = PotatoData();
  /// If for some reason the user's variety is not specified, the default variety is Saturna
  await potatoData.initializeWithAllDayData(variety);

  List<FlSpot> pastPredictionsLineChartData = [];
  List<FlSpot> forecastLineChartData = [];
  List<DHT22SensorData> sensorData = [];
  DataSnapshot data = await dataRef.get();
  List<DataSnapshot> dataList = data.children.toList();
  dataList.forEach((reading) {
    if(DHT22SensorData.checkValidValue(reading.value as Map<dynamic,dynamic>)){
      DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
      temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
      sensorData.add(temp);
    }
  });
  pastPredictionsLineChartData = await populatePastPredictionsLineChartData(avgTemperatureByHoursMaps: calculateAvgTemperatureAndHumidityByHours(sensorData, hours: 12), parameter: parameter, noOfDigitsAfterDecimal: noOfDigitsAfterDecimal, potatoData: potatoData);
  forecastLineChartData.add(pastPredictionsLineChartData.last);
  double index = pastPredictionsLineChartData.last.x;

  double T = avgTemperatureOfDay(sensorData).last;
  double RH = avgHumidityOfDay(sensorData).last;
  double initialWeight = 999; /// Read initial weight from user's data and remove this hardcoded initial value
  double transpirationRate = PotatoData.getTranspirationRate(T, RH);
  double? forecastData;
  for (; index < pastPredictionsLineChartData.last.x + 10; index++) {
    ////////////////////////////////////////////////////////////////////////////////
    switch(parameter) {
    //Total sugar
      case 'Total sugar':
        forecastData = await PotatoData().calculate_tot_sugar(index, T, RH);
        break;
    //pH
      case 'pH':
        forecastData = await PotatoData().calculate_ph(index, T, RH);
        break;
    //Starch
      case 'Starch':
        forecastData = await PotatoData().calculate_starch(index, T, RH);
        break;
    //Weight
      case 'Weight':
      // future is not required as no reading data from excel is done
        forecastData = PotatoData.getWeightloss(initialWeight, transpirationRate, index);
        break;
    //Reducing sugar
      case 'Reducing Sugar':
      forecastData = await potatoData.RS_day(index, T, PotatoData.rsAvg(variety: variety)) ?? -1;
      // forecastData *= 100000;
        break;
      default:
        print('Error in stream getData(). default case ran.');
    }
    forecastData = double.parse((forecastData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
    forecastLineChartData.add(FlSpot(index, forecastData));
  }

  return [pastPredictionsLineChartData, forecastLineChartData];
}