import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_login_ui/models/DHT22_sensor_data_model.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/common/firebase_storage.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/test/test2_line_chart_widget.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/test/prediction_line_chat_widget.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/test_line_chart_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scidart/numdart.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../common/utility_functions.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  XFile? selectedImage;

  Future pickImage() async{
   selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future uploadImage() async{
    final request = http.MultipartRequest("POST", Uri.parse('https://tcs-flask-api.herokuapp.com/upload'));
    final headers = {
      "Content-type":"multipart/form-data"
    };

    request.files.add(
      http.MultipartFile('image',selectedImage!.readAsBytes().asStream(), await selectedImage!.length(), filename: selectedImage!.path.split('/').last )
    );

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    var resJSON = await jsonDecode(jsonEncode(res.body));
    print(resJSON);
    setState((){});
  }

  Future<void> _refresh() async {
    setState((){});
    return Future.delayed(Duration(seconds: 1));
  }

  // List<double> avgTemperatureOfDay(List<DHT22SensorData> sensorData){
  //   List<double> avgTemperatureByDayList = [];
  //   int noOfPoints = 0;
  //   int prevDay = sensorData.first.timestamp.day;
  //   double avgTemperature = sensorData.first.temperatureReading;
  //   sensorData.asMap().forEach((i,dataPoint) {
  //     if(dataPoint.timestamp.day != prevDay){
  //       noOfPoints = 0;
  //       avgTemperatureByDayList.add(double.parse(avgTemperature.toStringAsFixed(1)));
  //       avgTemperature = 0;
  //       prevDay = dataPoint.timestamp.day;
  //     }
  //     avgTemperature = avgTemperature*noOfPoints + dataPoint.temperatureReading;
  //     avgTemperature = avgTemperature/ (noOfPoints+1);
  //     noOfPoints++;
  //   });
  //   avgTemperatureByDayList.add(double.parse(avgTemperature.toStringAsFixed(1)));
  //   return avgTemperatureByDayList;
  // }
  // List<double> avgHumidityOfDay(List<DHT22SensorData> sensorData){
  //   List<double> avgHumidityOfDayList = [];
  //   int noOfPoints = 0;
  //   int prevDay = sensorData.first.timestamp.day;
  //   double avgHumidity = sensorData.first.humidityReading;
  //   sensorData.asMap().forEach((i,dataPoint) {
  //     if(dataPoint.timestamp.day != prevDay){
  //       noOfPoints = 0;
  //       avgHumidityOfDayList.add(double.parse(avgHumidity.toStringAsFixed(1)));
  //       avgHumidity = 0;
  //       prevDay = dataPoint.timestamp.day;
  //     }
  //     avgHumidity = avgHumidity*noOfPoints + dataPoint.humidityReading;
  //     avgHumidity = avgHumidity/ (noOfPoints+1);
  //     noOfPoints++;
  //   });
  //   avgHumidityOfDayList.add(double.parse(avgHumidity.toStringAsFixed(1)));
  //   return avgHumidityOfDayList;
  // }

  // final DatabaseReference dataRef =
  // FirebaseDatabase.instance.ref().child('dummy-data');

  // Future getJSON(DatabaseReference dataRef) async{
  //   List<DHT22SensorData> sensorData = [];
  //   List<FlSpot> temperatureLineChartData = [];
  //   List<FlSpot> humidityLineChartData = [];
  //   DataSnapshot data = await dataRef.get();
  //   List<DataSnapshot> dataList = data.children.toList();
  //   dataList.forEach((reading) {
  //     DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
  //     temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
  //     sensorData.add(temp);
  //     temperatureLineChartData.add(FlSpot(double.parse(reading.key!), temp.temperatureReading));
  //     humidityLineChartData.add(FlSpot(double.parse(reading.key!), temp.humidityReading));
  //   });
  //   print(avgTemperatureOfDay(sensorData));
  //   print(avgHumidityOfDay(sensorData));
  // }


  ////////////////////////////////////////////////////////////////////////////
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
  Future<List<DHT22SensorData>> getSensorDataFromFirebase(DatabaseReference dataRef) async{
    List<DHT22SensorData> sensorData = [];
    DataSnapshot data = await dataRef.get();
    List<DataSnapshot> dataList = data.children.toList();
    dataList.forEach((reading) {
      DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
      temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
      sensorData.add(temp);
    });
    return sensorData;
  }

  final DatabaseReference dataRef =
  FirebaseDatabase.instance.ref().child('dummy-data');
  final DatabaseReference dataRef3 =
  FirebaseDatabase.instance.ref().child('dummy-data-2');
  final DatabaseReference dataRef2 =
  FirebaseDatabase.instance.ref().child('test');

  Future<List<FlSpot>> populatePastPredictionsLineChartData({required List<Map<String, double>> avgTemperatureByHoursMaps ,required List averageTemperatureOfDayList,required List averageHumidityOfDayList , int noOfDigitsAfterDecimal = 1, required String parameter, PotatoData? potatoData}) async {
    List<FlSpot> pastPredictionsLineChartData = [];
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //TODO: this is hardcoded variety = Saturna, change this to variety selected by user during signup
    PotatoData potatoData = PotatoData();
    await potatoData.initializeWithAllDayData('Saturna');
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    for(int index =0; index< avgTemperatureByHoursMaps.length; index++){
      if(avgTemperatureByHoursMaps[index]['avgT'] == -1000) continue ;
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
          predictedData = await potatoData.RS_day(time, T, PotatoData.calculateCurrentRSPercentage()) ?? -10;
          predictedData *= 100000;
          break;
        default:
          print('Error in populatePastPredictionsLineChartData. default case ran.');
          break;
      }
      ////////////////////////////////////////////////////////////////////////////////////////
      predictedData = double.parse((predictedData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
      pastPredictionsLineChartData.add(FlSpot(time, predictedData));
    }
    print(pastPredictionsLineChartData);
    return pastPredictionsLineChartData;
  }

  Future<List<List<FlSpot>>> getJSON(DatabaseReference dataRef, String parameter, {int noOfDigitsAfterDecimal = 1}) async{

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //TODO: this is hardcoded variety = Saturna, change this to variety selected by user during signup
    PotatoData potatoData = PotatoData();
    await potatoData.initializeWithAllDayData('Saturna');
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    List<FlSpot> pastPredictionsLineChartData = [];
    List<FlSpot> forecastLineChartData = [];
    List<DHT22SensorData> sensorData = [];
    DataSnapshot data = await dataRef.get();
    List<DataSnapshot> dataList = data.children.toList();
    dataList.forEach((reading) {
      DHT22SensorData temp = DHT22SensorData.fromJson(reading.value as Map<dynamic,dynamic>);
      temp.timestamp = DateTime.fromMillisecondsSinceEpoch( int.parse(reading.key!) * 1000);
      sensorData.add(temp);
    });
    pastPredictionsLineChartData = await populatePastPredictionsLineChartData(avgTemperatureByHoursMaps: calculateAvgTemperatureAndHumidityByHours(sensorData, hours: 6),averageHumidityOfDayList: avgHumidityOfDay(sensorData), averageTemperatureOfDayList: avgTemperatureOfDay(sensorData), parameter: parameter, noOfDigitsAfterDecimal: noOfDigitsAfterDecimal);
    forecastLineChartData.add(pastPredictionsLineChartData.last);
    double index = pastPredictionsLineChartData.last.x;

    double T = avgTemperatureOfDay(sensorData).last;
    double RH = avgHumidityOfDay(sensorData).last;
    double initialWeight = 999;
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
          forecastData = await potatoData.RS_day(index, T, PotatoData.calculateCurrentRSPercentage()) ?? -1;
          forecastData *= 100000;
          break;
        default:
          print('Error in stream getData(). default case ran.');
      }
      forecastData = double.parse((forecastData?.toStringAsFixed(noOfDigitsAfterDecimal))!);
      forecastLineChartData.add(FlSpot(index, forecastData));
    }

    return [pastPredictionsLineChartData, forecastLineChartData];
  }
  ////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Test",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text( DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(1655368249308))), //Reading Date form epoch timestamp
                // ElevatedButton(onPressed: () async {
                //   getJSON(dataRef);
                // }, child: Text('read')),
                Container(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.fromLTRB(0,0,28,0),
                  padding: EdgeInsets.fromLTRB(16,16,16,16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  width: double.infinity,
                  height: 250,
                  child: Column(
                    children: [
                      Expanded(child: Stack(
                        children: [
                          Test2LineChartWidget(),
                        ],
                      ),),
                      Text(
                        "           Time in MM:SS",
                        style : TextStyle(
                          color: Color(0xff75729e),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
      
                ),
                Container(
                  clipBehavior: Clip.none,
                  margin: EdgeInsets.fromLTRB(0,0,28,0),
                  padding: EdgeInsets.fromLTRB(16,16,16,16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  width: double.infinity,
                  height: 250,
                  child: Column(
                    children: [
                      Expanded(child: Stack(
                        children: [
                          PredictionLineChartWidget(parameter: 'Starch', digitsAfterDecimal: 1,)
                        ],
                      ),),
                      Text(
                        "           Time in days",
                        style : TextStyle(
                          color: Color(0xff75729e),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),

                ),
                ElevatedButton(onPressed: () async{
                  List<DHT22SensorData> sensorData = await getSensorDataFromFirebase(dataRef3);
                  List<Map<String, double>> avgTemperatureByHoursMaps = calculateAvgTemperatureAndHumidityByHours(sensorData, hours: 6);
                  print(avgTemperatureByHoursMaps);
                }, child: Text('press'))
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async{
                await pickImage();
                await uploadImage();
                // File path = File((selectedImage?.path)!);
                // String? filename = selectedImage?.path.split('/').last;
                // await FirebaseAuth.instance.signInAnonymously();
                // await storage.uploadImageToFirebaseStorage( path , filename!);
                print('Done');
              },
              child: Icon(Icons.download),
            ),
            SizedBox(width: 16,),
            ElevatedButton(
              onPressed: () async{
                final pdf = pw.Document();
                final List headers = ['SNo.','Time (days)',' Reducing Sugar'];
                final data = [
                  [1, 0, 0.001],
                  [2, 10, 0.002],
                  [3, 20, 0.0024],
                ];

                pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Table.fromTextArray(
                          headers: headers,
                          data: data); // Center
                    })); // Page
                final output = await getTemporaryDirectory();
                DateTime date = DateTime.now();
                final file = File("/storage/emulated/0/Download/example.pdf");
                await file.writeAsBytes(await pdf.save());
                print(output.path.runtimeType);
                print(await getExternalStorageDirectory());

              },
              child: Text('Save PDF'),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }



}
