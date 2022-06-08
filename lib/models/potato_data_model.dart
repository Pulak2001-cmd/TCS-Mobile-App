import 'dart:math';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

//Potato Model Class with all the relevant functions

class PotatoData {
  String? variety;
  String? varietyType;
  double? T_ref;
  double? k_ref;
  double? E;
  double? minT;
  double? maxT;
  String? model;


  PotatoData({
    this.variety,
    this.varietyType,
    this.T_ref,
    this. k_ref,
    this.E,
    this.minT,
    this.maxT,
    this.model = 'log',
  });

  //Functions which contain all the formulae

  double getRS(storageTime,T, currentRS) {
    double RSVal = currentRS - (k_ref! * exp(E! / 0.008314*(1/( T + 273.15) - T_ref!)))*storageTime;
    return RSVal;
  }

  //---------------------------Transpiration based models-----------------------------------------------------------------
  static double getTranspirationRate(T, rh){
    double k=1.0029;
    double A=-5.4661;
    double B=-1.5934;
    double tr = k*exp(A*(1/(T + 273.15) - 0.0033162)/0.000566542)*exp(B*((rh/100)-0.34)/0.56)*4.351 + 0.358;
    return tr;
  }
  //--------------------------------------------------------------------------------------------------------------------


  //------------------------------Weightloss----------------------------------------------------------------------
  static double getWeightloss(initialWeight, transpirationRate, time) {
    return initialWeight * (1 - (transpirationRate * time) / 1000);
  }

  static double calculateCurrentWeightlossPercentage() {
    return 5;
  }
  //--------------------------------------------------------------------------------------------------------------------


  //------------------------------Shelf Life----------------------------------------------------------------------
  static double calculateRemainingShelflife(currentWeightlossPercentage, tr) {
    tr = tr / 1000;
    return (10 - currentWeightlossPercentage) / (100 * tr);
  }

  //--------------------------------------------------------------------------------------------------------------------


  //------------------------------Reducing Sugar----------------------------------------------------------------------
  Future<double> RS_all_day(time, T, currentRS) async{
    double RSVal;
    if (model == 'log'){
      RSVal = currentRS*(1 - k_ref!*exp(E!/0.008314*(1/(T + 273.15) - T_ref!))*log(time + 1));
    }
    else{
      RSVal = currentRS - (k_ref!*exp(E!/0.008314*(1/(T + 273.15) - T_ref!)))*time;
    }
    return RSVal;
  }



  Future<double> RS_100_day(time, T, C_RS,) async{
    ByteData data = await rootBundle.load("assets/excel/RS_model.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var RS_model = Excel.decodeBytes(bytes);
    var data_CR = RS_model.tables['CR_day'];
    var data_CS = RS_model.tables['CS_day'];

    int n = 0;
    double Tot = 0;
    if (varietyType == "Cold-sensitive or High-sugar accumulating"){
      n = 0;
      Tot = 0;
      for (var row in (data_CS?.rows)!){
        if(row[2]?.value.runtimeType == String) continue;
        k_ref = row[2]?.value;
        T_ref = row[1]?.value;
        E = row[3]?.value;
        minT = row[4]?.value.toDouble();
        maxT =row[5]?.value.toDouble();
        if (T >= minT && T <= maxT) {
          Tot = (Tot + (k_ref! * exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref!))));
          n += 1;
        }
      }
    }
    else {
      n = 0;
      Tot = 0;
      for (var row in (data_CR?.rows)!){
        if(row[2]?.value.runtimeType == String) continue;
        k_ref = row[2]?.value;
        T_ref = row[1]?.value;
        E = row[3]?.value.toDouble();
        minT = row[4]?.value.toDouble();
        maxT =row[5]?.value.toDouble();
        if (T >= minT && T <= maxT) {
          Tot = (Tot + (k_ref! * exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref!))));
          n += 1;
        }
      }
    }
    if (n==0) return -1; // temperature not in range
    double RSVal = C_RS - Tot/n*time;
    return RSVal;
  }


  Future<double>? RS_day(time, temp, currentRSPercentage){
    if (variety != 'None'){
      return RS_all_day(time, temp, currentRSPercentage);
    }
    else if (varietyType != 'None'){
      return RS_100_day(time, temp, currentRSPercentage);
    }
    else{
      return null;
    }
  }


  double calculateCurrentRSPercentage() {
    return 0.001;
  }
  //------------------------------------------------------------------------------------------------

  //---------------------------------Sprouted Potato-----------------------------------------------
  static bool isImageSprouted(image) {
    int n = Random().nextInt(2); // random value assigned to n from {0,1}
    if (n == 0)
      return false;
    else
      return true;
    }

  //------------------------------------------------------------------------------------------------

  //-----------------------------------------pH------------------------------------------------------
  Future<double> calculate_ph(time, temp, rh) async{
    //Reading data from excel file and then saving sheet 'random_data' to variable pH_data EDIT: Sheet2 is used with values of random_data copy pasted as Values.
    ByteData data = await rootBundle.load("assets/excel/pH_data.xlsx"); //values in excel should be numerical values and not excel Formulas as it reads it directly and not the value given by excel formulae
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var pH_data = excel.tables['Sheet2'];

    int ALPHA = 5;
    int BETA = 2;
    int GAMA = 1;
    int TOTAL = 29;
    double minDistance = double.infinity;
    double closestStateVal = 0;
    for (var row in (pH_data?.rows)!) {
      if (row[2]?.value.runtimeType == String) continue;
      double distance = 0;
      double a1 = row[2]?.value.toDouble();
      double b1 = row[0]?.value.toDouble();
      double c1 = row[1]?.value.toDouble();

      double a = (a1 - time);
      double b = (b1 - temp);
      double c = (c1 - rh);


      distance += (pow(a, 2) * ALPHA);
      distance += ((pow(b,2) * BETA));
      distance += ((pow(c,2) * GAMA));
      if (distance < minDistance) {
        minDistance = distance;
        closestStateVal = row[3]?.value;
      }
    }
    return closestStateVal;
  }

  Future<List<double>> calculate_ph_vectorized(timeVec, temp, rh) async{
    List<double> res = [];
    var time;
    double pH;
    for (time in timeVec) {
      pH = await calculate_ph(time, temp, rh);
      res.add(pH);
    }
    return res;
  }


  //-----------------------------------------------------------------------------------------------------


  //---------------------------------------Potato Appearance------------------------------------------
  String filename_for_potato(time, temp) {
    var temperature = {
      'T1': 0,
      'T2': 3,
      'T3': 6,
      'T4': 9,
      'T5': 12,
      'T6': 15,
      'T7': 18,
      'T8': 21,
      'T9': 24,
      'T10': 27,
      'T11': 30
    };

    var closestTemperature = 'T1';

    int? minDifference = 10000000;

    temperature.forEach((key, value) {
      if ((value - temp).abs() < minDifference!){
        minDifference = (value - temp).abs() as int?;
        closestTemperature = key;
      }
    });


    return "images/Potato/" + closestTemperature + '/' + closestTemperature + '_D' + time.toString() + '.jpg';
  }

  //-----------------------------------------------------------------------------------------------------

  //-----------------------------------------Total Sugars---------------------------------------------------
  Future<double> calculate_tot_sugar(time, temp, rh) async{

    //Reading data from excel file and then saving sheet 'random_data' to variable pH_data
    ByteData data = await rootBundle.load("assets/excel/pH_data.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var pH_data = excel.tables['Sheet2'];

    int ALPHA = 5;
    int BETA = 2;
    int GAMA = 1;
    int TOTAL = 29;
    double minDistance = 1000000;
    double closestStateVal = 0;
    for (var row in (pH_data?.rows)!) {
      if(row[2]?.value.runtimeType == String) continue;
      double distance = 0;
      distance += ((pow(row[2]?.value - time, 2) * ALPHA));
      distance += ((pow(row[0]?.value - temp,2) * BETA));
      distance += ((pow(row[1]?.value - rh,2) * GAMA));
      if (distance < minDistance) {
        minDistance = distance;
        closestStateVal = row[5]?.value;
      }
    }
    return closestStateVal;
  }

  Future<List<double>> calculate_tot_sugar_vectorized(timeVec, temp, rh) async{
    List<double> res = [];
    var time;
    double totalSugar = 0;
    for (time in timeVec) {
      totalSugar = await calculate_tot_sugar(time, temp, rh);
      res.add(totalSugar);
    }
    return res;
  }

  //-----------------------------------------------------------------------------------------------------

  //-----------------------------------------Starch---------------------------------------------------

  Future<double> calculate_starch(time, temp, rh) async{
    //Reading data from excel file and then saving sheet 'random_data' to variable pH_data
    ByteData data = await rootBundle.load("assets/excel/pH_data.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var pH_data = excel.tables['Sheet2'];

    int ALPHA = 5;
    int BETA = 2;
    int GAMA = 1;
    int TOTAL = 29;
    double minDistance = double.infinity;
    double closestStateVal = 0;
    for (var row in (pH_data?.rows)!) {
      if(row[2]?.value.runtimeType == String) continue;
      double distance = 0;
      distance += (pow(row[2]?.value - time, 2) * ALPHA);
      distance += (pow(row[0]?.value - temp,2) * BETA);
      distance += (pow(row[1]?.value - rh,2) * GAMA);
      if (distance < minDistance) {
        minDistance = distance;
        closestStateVal = row[4]?.value;
      }
    }
    return closestStateVal;
  }

  Future<List<double>> calculate_starch_vectorized(timeVec, temp, rh) async{
    List<double> res = [];
    var time;
    double starch = 0;
    for (time in timeVec) {
      starch = await calculate_starch(time, temp, rh);
      res.add(starch);
    }
    return res;
  }


 //---------------------------------------------------------------------------------------------------------

//-----------------------------------------Time Manipulation---------------------------------------------------
  double timeDifferenceInDays(DateTime to,DateTime from){
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    double differenceInDays = (to.difference(from).inHours / 24);
    return differenceInDays;
  }


  double timeDifferenceInSeconds(DateTime to, DateTime from){
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    double differenceInSeconds = (to.difference(from).inHours * 60);
    return differenceInSeconds;
  }

  //returns new Date after subtracting provided time in seconds from provided Date
  DateTime sub_time(DateTime time, int seconds) {
    return time.subtract(Duration(seconds: seconds));
  }

  //returns new Date after adding provided time in seconds from provided Date
  DateTime add_time(DateTime time, int seconds) {
    return time.add(Duration(seconds: seconds));
  }


  List<List> tacia(time) {
    int TOTAL_POINTS = 30;
    int TOTAL_POINTS_IN_DATABASE = time.length;
    int ACCEPTABLE_TIME_DIFFERENCE = 100;
    DateTime first_time_data_upload = time[0];
    DateTime last_time_data_upload = time[-1];
    double tot_time_difference_seconds = timeDifferenceInSeconds(last_time_data_upload, first_time_data_upload);
    int time_gap = (tot_time_difference_seconds / TOTAL_POINTS).round();
    List<double> time_array = [timeDifferenceInDays(last_time_data_upload, first_time_data_upload),];
    List<int?> index_array = [TOTAL_POINTS_IN_DATABASE - 1,];
    int pointer = TOTAL_POINTS_IN_DATABASE - 2;
    int point_count = 1;
    while (pointer >= 0 && point_count < TOTAL_POINTS) {
      int req_time_difference = point_count * time_gap;
      if ((timeDifferenceInSeconds(last_time_data_upload, time[pointer]) - req_time_difference).abs() <= ACCEPTABLE_TIME_DIFFERENCE) {
        time_array.add(timeDifferenceInDays(time[pointer], first_time_data_upload));
        index_array.add(pointer);
        point_count += 1;
      }
      if (timeDifferenceInSeconds(last_time_data_upload, time[pointer]) - req_time_difference > ACCEPTABLE_TIME_DIFFERENCE) {
        point_count += 1;
        time_array.add(timeDifferenceInDays(
            sub_time(last_time_data_upload, req_time_difference),
            first_time_data_upload));
        index_array.add(null);
        pointer -= 1;
      }
    }
    time_array = new List.from(time_array.reversed);
    index_array = new List.from(index_array.reversed);
    return [time_array, index_array];
  }
  List get_values(parameter_list, index_array ) {
    List res = [];
    for (var index in index_array) {
      index == null ? res.add(null) : res.add(parameter_list[index]);
    }
    return res;
  }
}






