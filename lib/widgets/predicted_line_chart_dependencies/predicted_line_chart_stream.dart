import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import '../../models/potato_data_model.dart';

Future<List<FlSpot>> populatePastPredictionsLineChartData({required List sensorData, int noOfDigitsAfterDecimal = 1, required String parameter, PotatoData? potatoData}) async {
  List<FlSpot> pastPredictionsLineChartData = [];

  for(int index =0; index< sensorData.length; index++){
    double T = double.parse(sensorData[index]["T"]);
    double RH = double.parse(sensorData[index]["RH"]);
    double initialWeight = double.parse(sensorData[index]["Initial Weight"]!);
    double transpirationRate = PotatoData.getTranspirationRate(double.parse(sensorData[index]["T"]), double.parse(sensorData[index]["RH"]));
    Duration time = DateTime.parse(sensorData[index]["Current Date"]).difference(DateTime.parse(sensorData[index]["Start Date"]));
    ////////////////////////////////////////////////////////////////////////////////////////
    double? predictedData;
    switch(parameter) {
      //Total sugar
      case 'Total sugar':
        predictedData = await PotatoData().calculate_tot_sugar(time.inDays, T, RH);
        break;
      //pH
      case 'pH':
        predictedData = await PotatoData().calculate_ph(time.inDays, T, RH);
        break;
      //Starch
      case 'Starch':
        predictedData = await PotatoData().calculate_starch(time.inDays, T, RH);
        break;
      //Weight
      case 'Weight':
        // "await" not required as no data is read from excel file
        predictedData = PotatoData.getWeightloss(initialWeight, transpirationRate, time.inDays);
        break;
      //Reducing sugar
      case 'Reducing Sugar':
        predictedData = await potatoData?.RS_day(time.inDays, T, PotatoData.calculateCurrentRSPercentage()) ?? -10;
        break;
      default:
        print('Error in populatePastPredictionsLineChartData. default case ran.');
        break;
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    predictedData = double.parse((predictedData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
    pastPredictionsLineChartData.add(FlSpot(time.inDays.toDouble(), predictedData));
  }
  return pastPredictionsLineChartData;
}

Stream<List<List<FlSpot>>> getData({required String parameter,required int noOfDigitsAfterDecimal}) async* {

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //TODO: this is hardcoded variety = Saturna, change this to variety selected by user during signup
  PotatoData potatoData = PotatoData();
  await potatoData.initializeWithAllDayData('Saturna');
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  while (true) {
    await Future.delayed(Duration(milliseconds: 5000));
    http.Response response = await http.get(Uri.parse(
        'https://6295fb06810c00c1cb6ca55f.mockapi.io/api/weight-data'));
    List sensorData = jsonDecode(response.body);
    List<FlSpot> pastPredictionsLineChartData = [];
    List<FlSpot> forecastLineChartData = [];
    // double index = sensorData.length.toDouble();

    List<FlSpot> data = await populatePastPredictionsLineChartData(sensorData: sensorData, noOfDigitsAfterDecimal: noOfDigitsAfterDecimal, parameter: parameter, potatoData: potatoData);
    forecastLineChartData.add(data.last);
    pastPredictionsLineChartData = data;
    double index = pastPredictionsLineChartData.last.x;

    double T = double.parse(sensorData.last["T"]);
    double RH = double.parse(sensorData.last["RH"]);
    double initialWeight = double.parse(sensorData.last["Initial Weight"]!);
    double transpirationRate = PotatoData.getTranspirationRate(double.parse(sensorData.last["T"]), double.parse(sensorData.last["RH"]));
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
          forecastData = await potatoData.RS_day(index, T, PotatoData.calculateCurrentRSPercentage()) ?? -1;
          break;
        default:
          print('Error in stream getData(). default case ran.');
      }
      forecastData = double.parse((forecastData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
      forecastLineChartData.add(FlSpot(index, forecastData));
    }
    yield [pastPredictionsLineChartData, forecastLineChartData];
  }
}