/// /////////////////////////////////////////////////////////////////////////
/// //////// Potato Model Class with all the mathematical models ////////////
/// /////////////////////////////////////////////////////////////////////////

import 'dart:math';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';



class PotatoData {
  String? variety;
  String? varietyType;
  double? T_ref_reciprocal;
  double? T_ref;
  double? k_ref;
  double? E;
  double? minT;
  double? maxT;
  String? model;


  PotatoData({
    this.variety = 'None',
    this.varietyType = 'Cold-sensitive or High-sugar accumulating',
    this.T_ref_reciprocal ,
    this.k_ref ,
    this.E ,
    this.minT,
    this.maxT,
    this.model,
  });



  Future initializeWithAllDayData(String selectedVariety, {String selectedVarietyType = 'Cold-sensitive or High-sugar accumulating'}) async {
    ByteData data = await rootBundle.load("assets/excel/RS_model.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var RS_model = Excel.decodeBytes(bytes);
    var all_data = RS_model.tables['all_day'];
    this.variety = selectedVariety;
    this.varietyType = selectedVarietyType;
    for (var row in (all_data?.rows)!) {
      if (row[0]?.value == selectedVariety) {
        this.k_ref = row[3]?.value;
        this.T_ref_reciprocal = row[2]?.value;
        this.E = row[4]?.value.runtimeType == double ? row[4]?.value : row[4]?.value.toDouble();
        this.T_ref = row[5]?.value.runtimeType == double ? row[5]?.value : row[5]?.value.toDouble();
        this.model = row[1]?.value;

      }
    }

  }

  //----------------------------------------------------------------------------------------------------
  int closest_conditions(temp,rh,Map mapping) {

    int closest_index = 0;
    double min_distance = double.infinity;
    mapping.forEach((key, value) {
      double distance = pow((mapping[key]['temp'] - temp),2)*1.0 +  pow((mapping[key]['rh'] - rh),2);
      if (distance < min_distance) {
        closest_index = key;
        min_distance = distance;
      }
    });
    return closest_index;
    }


  int lowerbound( time, List datapoint_collection_time) {
    int lower_index = 0;
    datapoint_collection_time.asMap().forEach((index,value){
    if (time >= value)
      lower_index = index;
    });
    return lower_index;
  }


  int upperbound( time,List datapoint_collection_time){
    int upper_index = datapoint_collection_time.length;
    datapoint_collection_time.asMap().forEach((index,value) {
      if (time > value){

      } else {
        upper_index = index;
      }
    });
    return upper_index;
  }


  double interpolate(time, data, datapoint_collection_time) {
    int upperbound_index = upperbound(time, datapoint_collection_time);
    int lowerbound_index = lowerbound(time, datapoint_collection_time);
    if (lowerbound_index == 0) {
      return data[0];
    }
    if (upperbound_index == datapoint_collection_time.length) {
      return data.last;
    }

    if (lowerbound_index == upperbound_index) {
      return data[lowerbound_index];
    }
    double u = datapoint_collection_time[upperbound_index].toDouble();
    double l = datapoint_collection_time[lowerbound_index].toDouble();
    double result = double.parse((((time - l) * data[upperbound_index] + (u - time) * data[lowerbound_index])/(u - l)).toStringAsFixed(5));
    return result;
  }

  //----------------------------------------------------------------------------------------------------

    /////////////////////////////////// Transpiration based models /////////////////////////////////////////
    static double getTranspirationRate(T, rh) {
      double k = 1.0029;
      double A = -5.4661;
      double B = -1.5934;
      double tr = k * exp(A * (1 / (T + 273.15) - 0.0033162) / 0.000566542) *
          exp(B * ((rh / 100) - 0.34) / 0.56) * 4.351 + 0.358;
      return tr;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////// Weight loss ////////////////////////////////////////////////////////
    /// Function that predicts weight loss using initialWeight, tr & time as parameters
    static double getWeightloss(initialWeight, transpirationRate, time) {
      return initialWeight * (1 - (transpirationRate * time) / 1000);
    }
   /// Function that calculates weight loss percentage using initialWeight and currentWeight as parameters
    static double calculateCurrentWeightlossPercentage(double initialWeight, double currentWeight) {
      return (initialWeight - currentWeight)*100/initialWeight;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //------------------------------Shelf Life----------------------------------------------------------------------
    static double calculateRemainingShelflife(currentWeightlossPercentage, tr) {
      tr = tr / 1000;
      return (10 - currentWeightlossPercentage) / (100 * tr);
    }

    //--------------------------------------------------------------------------------------------------------------------


    //------------------------------Reducing Sugar----------------------------------------------------------------------
  static double getAvgPotatoRS(Map rsAvgVariety) {
    double total = 0;
    int count = 0;
    rsAvgVariety.forEach((key, value) {
      total += value;
      count +=1;
    });
    return double.parse((total / count).toStringAsFixed(2));
  }
  static double rsAvg({String variety = 'None', String varietyType = 'None'}) {
    Map<String, double> rsAvgVariety = {
      'Saturna': 0.054,
      'Kennebec': 0.04,
      'Agria': 0.230,
      'Toyoshiro': 0.05,
      'K Lauvkar': 0.075,
      'K Chipsona1': 0.028,
      'K Jyoti': 0.35,
      'Wu-foon': 0.355,
      'Norchip': 0.006,
      'K Badshah': 0.06,
      'K Chipsona2': 0.12,
      'Vangodh': 0.3,
      'Bintje': 0.2,
      'Simcoe': 0.015,
      'Onaway': 0.04,
      'Cardinal': 0.2
    };
    Map<String, double> coldResistanceAvgValue = {
      'Cold-sensitive or High-sugar accumulating': 0.08683,
      'Cold-resistant or Low-sugar accumulating': 0.1844,
    };
    if (variety != 'None') {
      return rsAvgVariety[variety]!;
    }
    if (varietyType != 'None') {
      return coldResistanceAvgValue[varietyType]!;
    }
    else {
      return getAvgPotatoRS(rsAvgVariety);
    }
  }

    Future<double> RS_all_day(time, T, currentRS) async {
      ByteData data = await rootBundle.load("assets/excel/RS_model.xlsx");
      var bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      var RS_model = Excel.decodeBytes(bytes);
      var all_data = RS_model.tables['all_day'];

      double RSVal = 0;
      for (var row in (all_data?.rows)!) {
        if (row[0]?.value == variety) {
          k_ref = row[3]?.value;
          T_ref_reciprocal = row[2]?.value;
          E = row[4]?.value;

          if (model == 'log') {
            RSVal = currentRS * (1 - k_ref! *
                exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref_reciprocal!)) *
                log(time + 1));

          }
          else {
            RSVal = currentRS - (k_ref! * exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref_reciprocal!))) * time;

          }
      }
    }
      return RSVal;
  }


    Future<double> RS_100_day(time, T, C_RS,) async {
      ByteData data = await rootBundle.load("assets/excel/RS_model.xlsx");
      var bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      var RS_model = Excel.decodeBytes(bytes);
      var data_CR = RS_model.tables['CR_day'];
      var data_CS = RS_model.tables['CS_day'];
      int n = 0;
      double Tot = 0;
      if (varietyType == "Cold-sensitive or High-sugar accumulating") {
        n = 0;
        Tot = 0;
        for (var row in (data_CS?.rows)!) {
          if (row[2]?.value.runtimeType == String) continue;
          k_ref = row[2]?.value;
          T_ref_reciprocal = row[1]?.value;
          E = row[3]?.value;
          minT = row[4]?.value.toDouble();
          maxT = row[5]?.value.toDouble();
          if (T >= minT && T <= maxT) {
            Tot = (Tot + (k_ref! *
                exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref_reciprocal!))));
            n += 1;
          }
        }
      }
      else {
        n = 0;
        Tot = 0;
        for (var row in (data_CR?.rows)!) {
          if (row[2]?.value.runtimeType == String) continue;
          k_ref = row[2]?.value;
          T_ref_reciprocal = row[1]?.value;
          E = row[3]?.value.toDouble();
          minT = row[4]?.value.toDouble();
          maxT = row[5]?.value.toDouble();
          if (T >= minT && T <= maxT) {
            Tot = (Tot + (k_ref! *
                exp(E! / 0.008314 * (1 / (T + 273.15) - T_ref_reciprocal!))));
            n += 1;
          }
        }
      }
      if (n == 0) return -1; // temperature not in range
      double RSVal = C_RS - Tot / n * time;
      return RSVal;
    }


    Future<double>? RS_day(time, temp, currentRSPercentage) {
      if (variety != 'None') {
        return RS_all_day(time, temp, currentRSPercentage);
      }
      else if (varietyType != 'None') {
        return RS_100_day(time, temp, currentRSPercentage);
      }
      else {
        return null;
      }
    }


    static double calculateCurrentRSPercentage() {
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


    Future<double> calculate_ph(time, temp, rh) async {
      //Reading data from excel file and then saving sheet 'random_data' to variable pH_data EDIT: Sheet2 is used with values of random_data copy pasted as Values.
      ByteData data = await rootBundle.load(
          "assets/excel/pH_data_2.xlsx"); //values in excel should be numerical values and not excel Formulas as it reads it directly and not the value given by excel formulae
      var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);
      var pH_data = excel.tables['ph'];
      // print(pH_data?.rows[0][0]?.value);
      Map mapping = {
        1: {
          'temp': 21.9,
          'rh': 65
        },
        2: {
          'temp': 21.6,
          'rh': 72,
        },
        3: {
          'temp': 21.4,
          'rh': 89,
        },
        4: {
          'temp': 10.3,
          'rh': 35.9,
        },
        5: {
          'temp': 9.7,
          'rh': 68.4
        }
      };
      int index = closest_conditions(temp, rh, mapping);
      List<double> columnIndex = [];
      for (var row in (pH_data?.rows)!) {
        if(row[0]?.value.runtimeType == String) continue;
        columnIndex.add(row[index]?.value);
      }
      List<int> columnDay = [];
      for (var row in (pH_data?.rows)!) {
        if(row[0]?.value.runtimeType == String) continue;
        columnDay.add(row[0]?.value); //Column 0 has Day data in excel file
      }


      return interpolate(time, columnIndex, columnDay);
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
        if ((value - temp).abs() < minDifference!) {
          minDifference = (value - temp).abs() as int?;
          closestTemperature = key;
        }
      });


      return "images/Potato/" + closestTemperature + '/' + closestTemperature +
          '_D' + time.toString() + '.jpg';
    }

    //-----------------------------------------------------------------------------------------------------

    //-----------------------------------------Total Sugars---------------------------------------------------

    Future<double> calculate_tot_sugar(time, temp, rh) async {
    ByteData data = await rootBundle.load(
        "assets/excel/pH_data_2.xlsx"); //values in excel should be numerical values and not excel Formulas as it reads it directly and not the value given by excel formulae
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var tot_sugar_data = excel.tables['tot_sugar'];
    Map mapping = {
      1: {
        'temp':25.6,
        'rh':68
      },
      2:{
        'temp':24.9,
        'rh':60,
      },
      3:{
        'temp':25,
        'rh': 93,
      },
      4:{
        'temp':25.4,
        'rh':48.7,
      },
      5:{
        'temp':15.3,
        'rh':48
      },
      6:{
        'temp':10.8,
        'rh':34.1
      },
      7:{
        'temp':-15.6,
        'rh': 40
      },
      8:{
        'temp':28.4,
        'rh':34.3
      },
      9:{
        'temp':5,
        'rh':90
      }
    };
    int index = closest_conditions(temp, rh, mapping);
    List<double> columnIndex = [];
    for (var row in (tot_sugar_data?.rows)!) {
      if(row[0]?.value.runtimeType == String) continue;
      columnIndex.add(row[index]?.value);
    }
    List<int> columnDay = [];
    for (var row in (tot_sugar_data?.rows)!) {
      if(row[0]?.value.runtimeType == String) continue;
      columnDay.add(row[0]?.value); //Column 0 has Day data in excel file
    }


    return interpolate(time, columnIndex, columnDay);
  }

    /// Unused function created because a similiar function exits in website's app.py
    Future<List<double>> calculate_tot_sugar_vectorized(timeVec, temp,
        rh) async {
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

  Future<double> calculate_starch(time, temp, rh) async {
    ByteData data = await rootBundle.load(
        "assets/excel/pH_data_2.xlsx"); //values in excel should be numerical values and not excel Formulas as it reads it directly and not the value given by excel formulae
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var starch_data = excel.tables['tot_sugar'];
    Map mapping = {
      1: {
        'temp':21.9,
        'rh':65
      },
      2:{
        'temp':21.6,
        'rh':72,
      },
      3:{
        'temp':21.4,
        'rh': 89,
      },
      4:{
        'temp':27.6,
        'rh':8.7,
      },
      5:{
        'temp':-9.7,
        'rh':38.6
      },
      6:{
        'temp':10.3,
        'rh':35.9
      },
      7:{
        'temp':9.7,
        'rh':68.4
      }
    };
    int index = closest_conditions(temp, rh, mapping);
    List<double> columnIndex = [];
    for (var row in (starch_data?.rows)!) {
      if(row[0]?.value.runtimeType == String) continue;
      columnIndex.add(row[index]?.value);
    }
    List<int> columnDay = [];
    for (var row in (starch_data?.rows)!) {
      if(row[0]?.value.runtimeType == String) continue;
      columnDay.add(row[0]?.value); //Column 0 has Day data in excel file
    }


    return interpolate(time, columnIndex, columnDay);
  }
    /// Unused function created because a similiar function exits in website's app.py
    Future<List<double>> calculate_starch_vectorized(timeVec, temp, rh) async {
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
    /// Unused function created because a similiar function exits in website's app.py
    double timeDifferenceInDays(DateTime to, DateTime from) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      double differenceInDays = (to
          .difference(from)
          .inHours / 24);
      return differenceInDays;
    }

  /// Unused function created because a similiar function exits in website's app.py
    double timeDifferenceInSeconds(DateTime to, DateTime from) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      double differenceInSeconds = (to
          .difference(from)
          .inHours * 60);
      return differenceInSeconds;
    }

  /// Unused function created because a similiar function exits in website's app.py
    //returns new Date after subtracting provided time in seconds from provided Date
    DateTime sub_time(DateTime time, int seconds) {
      return time.subtract(Duration(seconds: seconds));
    }
  /// Unused function created because a similiar function exits in website's app.py
    //returns new Date after adding provided time in seconds from provided Date
    DateTime add_time(DateTime time, int seconds) {
      return time.add(Duration(seconds: seconds));
    }

  /// Unused function created because a similiar function exits in website's app.py
    List<List> tacia(time) {
      int TOTAL_POINTS = 30;
      int TOTAL_POINTS_IN_DATABASE = time.length;
      int ACCEPTABLE_TIME_DIFFERENCE = 100;
      DateTime first_time_data_upload = time[0];
      DateTime last_time_data_upload = time[-1];
      double tot_time_difference_seconds = timeDifferenceInSeconds(
          last_time_data_upload, first_time_data_upload);
      int time_gap = (tot_time_difference_seconds / TOTAL_POINTS).round();
      List<double> time_array = [
        timeDifferenceInDays(last_time_data_upload, first_time_data_upload),
      ];
      List<int?> index_array = [TOTAL_POINTS_IN_DATABASE - 1,];
      int pointer = TOTAL_POINTS_IN_DATABASE - 2;
      int point_count = 1;
      while (pointer >= 0 && point_count < TOTAL_POINTS) {
        int req_time_difference = point_count * time_gap;
        if ((timeDifferenceInSeconds(last_time_data_upload, time[pointer]) -
            req_time_difference).abs() <= ACCEPTABLE_TIME_DIFFERENCE) {
          time_array.add(
              timeDifferenceInDays(time[pointer], first_time_data_upload));
          index_array.add(pointer);
          point_count += 1;
        }
        if (timeDifferenceInSeconds(last_time_data_upload, time[pointer]) -
            req_time_difference > ACCEPTABLE_TIME_DIFFERENCE) {
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
  /// Unused function created because a similiar function exits in website's app.py
    List get_values(parameter_list, index_array) {
      List res = [];
      for (var index in index_array) {
        index == null ? res.add(null) : res.add(parameter_list[index]);
      }
      return res;
    }
  }

