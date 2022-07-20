import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/providers/temp_crop_list_provider.dart';
import 'package:flutter_login_ui/widgets/bottom_modal_sheet_quality_of_lots.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_login_ui/common/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/crop_status_model.dart';
import '../../providers/current_dashboard_provider.dart';
import '../../widgets/bottom_modal_sheet_crop_status.dart';

class QualityOfLotsScreen extends StatefulWidget {
  const QualityOfLotsScreen({Key? key}) : super(key: key);

  @override
  State<QualityOfLotsScreen> createState() => _QualityOfLotsScreenState();
}

class _QualityOfLotsScreenState extends State<QualityOfLotsScreen> {

  Future<void> _refresh() async {
    setState((){});
    return Future.delayed(Duration(seconds: 1));
  }
  final Storage storage = Storage();

  Future uploadImage(String imageURL) async{
    String apiEndPoint = 'https://tcs-flask-api.herokuapp.com/test';
    Map data = {
      'imageURL': imageURL
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(apiEndPoint),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    if (response.statusCode == 200)
      return response;
    return null;
  }

  Future runModels(List<String> imageURLS) async{
    var response;
    String diseaseStatus;
    String sproutStatus;
    String weightlossStatus;
    String overallHealthStatus = 'Healthy';

    // for(int i =0; i<2; i++){
    //   Provider.of<CropListProvider>(context,listen: false).addCropStatus(CropStatus(diseaseStatus: 'Not diseased',overallHealthStatus: 'Healthy', sproutStatus: 'Not Sprouted', weightLossStatus: 'Weight loss < 10%', image:imageURLS[i]));
    // }
    //
    // Future.delayed(Duration(seconds: 5), (){
    //   Provider.of<CropListProvider>(context, listen: false).removeAt(1);
    //   Provider.of<CropListProvider>(context,listen: false).addCropStatus(CropStatus(diseaseStatus: 'Not diseased',overallHealthStatus: 'Unhealthy', sproutStatus: 'Sprouted', weightLossStatus: 'Weight loss < 10%', image:imageURLS[2]));
    // });




    imageURLS.forEach((imageURL) async {
      response = await uploadImage(imageURL);
      response = jsonDecode(response.body);
      diseaseStatus = double.parse(response['disease status'][1]) == 1? 'Diseased':'Not diseased';
      sproutStatus = double.parse(response['sprout status'][1]) == 1? 'Sprouted':'Not Sprouted';
      weightlossStatus = double.parse(response['weight loss status'][1]) == 1? 'Weight loss > 10%':'Weight loss < 10%';
      if(diseaseStatus == 'Diseased' || sproutStatus == 'Sprouted' || weightlossStatus == 'Weight loss > 10%'){
        overallHealthStatus = 'Unhealthy';
      }
      // WidgetsBinding.instance.addPostFrameCallback((_) => );
      Provider.of<CropListProvider>(context,listen: false).addCropStatus(CropStatus(diseaseStatus: diseaseStatus,overallHealthStatus: overallHealthStatus, sproutStatus: sproutStatus, weightLossStatus: weightlossStatus, image:imageURL));

    });
  }
  double currentDashboard = 1;


  @override
  Widget build(BuildContext context) {
    double currentDashboard = Provider.of<DashboardProvider>(context).currentDashboard;

    // WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<CropListProvider>(context,listen: false).addCropStatus(CropStatus(overallHealthStatus: 'Healthy')));
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
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: currentDashboard == 1 ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ) :ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0.0),
                          ),
                          onPressed: (){
                            Provider.of<DashboardProvider>(context, listen: false).setDashboard(1);
                            setState((){});
                          },
                          child: Text(
                            'System 1',
                            style: TextStyle(
                                color: Colors.white70
                            ),)),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: ElevatedButton(
                          style: currentDashboard == 2 ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ) :ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white70),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0.0),
                          ),
                          onPressed: (){
                            Provider.of<DashboardProvider>(context, listen: false).setDashboard(2);
                            setState((){});
                          },
                          child: Text(
                            'System 2',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              SizedBox(height: 16,),
              Text(
                'Tap to see more details',
                style: TextStyle(
                  color: Colors.white70,

                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: storage.listFiles(),
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot)  {
                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                      List<String> imageURLS = snapshot.data?[1];
                      runModels(imageURLS);

                      return Container(
                        child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: snapshot.data?[1].length,
                          itemBuilder: (context, index) {

                            return Card(
                              color: Provider.of<CropListProvider>(context).cropStatusList.length != 0 ? Provider.of<CropListProvider>(context).cropStatusList[index].overallHealthStatus=='Healthy' ? HexColor('#A5E1AD') : HexColor('#FF5C58'): Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data?[1][index]),
                                ),
                                title: Text(
                                  'Potato',
                                  style:TextStyle(
                                    color: HexColor('#423F46'),
                                    fontWeight: FontWeight.bold,
                                  ), ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.seedling,
                                      color: HexColor('#423F46'),
                                    ),
                                    SizedBox(width: 10,),
                                    Icon(
                                      FontAwesomeIcons.scaleUnbalanced,
                                      color: HexColor('#423F46'),
                                    ),
                                    SizedBox(width: 14,),
                                    Icon(
                                      FontAwesomeIcons.virus,
                                      color: HexColor('#423F46'),
                                    ),
                                  ],
                                ),
                                onTap: ()=> showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => buildSheetQualityOfLots(context, Provider.of<CropListProvider>(context,listen: false).cropStatusList[index], NetworkImage(snapshot.data?[1][index])),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            );
                          },
                          // physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                    );

                    }
                    if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
