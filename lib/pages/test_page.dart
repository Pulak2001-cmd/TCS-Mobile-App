import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  // void getData() async{
  //   Response response = await get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
  //   List temperatureData = jsonDecode(response.body);
  //   List<FlSpot> lineChartData = [];
  //   double index =0;
  //   temperatureData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["T"]!))));
  //   print(lineChartData);
  // }
  //
  // Stream<List<FlSpot>> DHT22Stream() async* {
  //   while (true) {
  //     await Future.delayed(Duration(milliseconds: 500));
  //     Response response = await get(Uri.parse('https://6295fb06810c00c1cb6ca55f.mockapi.io/api/temperature-data'));
  //     List temperatureData = jsonDecode(response.body);
  //     List<FlSpot> lineChartData = [];
  //     double index =0;
  //     temperatureData.forEach((temp) => lineChartData.add(FlSpot(index++, double.parse(temp["T"]!))));
  //     yield lineChartData;
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
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
          child: ElevatedButton(
            onPressed: (){
              uploadImage();
            },
            child: Text('Upload'),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () async{
            await pickImage();
            uploadImage();

          },
          child: Icon(Icons.download),
        ),
      ),
    );
  }



}
