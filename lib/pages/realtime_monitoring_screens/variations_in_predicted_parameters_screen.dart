import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/widgets/prediction_line_chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../models/user_model.dart';
import '../../providers/current_dashboard_provider.dart';

class VariationsInPredictedParametersScreen extends StatefulWidget {
  const VariationsInPredictedParametersScreen({Key? key}) : super(key: key);

  @override
  State<VariationsInPredictedParametersScreen> createState() => _VariationsInPredictedParametersScreenState();
}

class _VariationsInPredictedParametersScreenState extends State<VariationsInPredictedParametersScreen> {
  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
  }

  int activeIndex1 =0;

  final urls = [
    '1','2','3','4'
  ];

  Future refresh() async{
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dataRef = Provider.of<DashboardProvider>(context).dataRef;
    // DatabaseReference dataRef = FirebaseDatabase.instance.ref().child('test');
    double currentDashboard = Provider.of<DashboardProvider>(context).currentDashboard;
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
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
                              setState((){
                                dataRef = FirebaseDatabase.instance.ref().child('test');
                              });
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
                              setState((){
                                dataRef = FirebaseDatabase.instance.ref().child('sensor-2');
                              });
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Variations in predicted parameters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Column(children:[
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Legend',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GradientText(
                                  'Past predictions',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  colors: [
                                    Colors.red[200]!,
                                    Colors.red[500]!,
                                  ],
                                ),
                                SizedBox(width: 16,),
                                GradientText(
                                  'Forecast (10 days)',
                                  colors: [
                                    Colors.yellow[200]!,
                                    Colors.yellow[500]!,
                                  ],
                                ),
                            ],)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text(
                      'Weight (kg)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Weight', digitsAfterDecimal: 0, dataRef: dataRef,)),
                    Text(
                      'Reducing Sugar (%w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // buildGraph(PredictionLineChartWidget(parameter: 'Reducing Sugar', digitsAfterDecimal: 1, dataRef: dataRef)),
                    StreamBuilder<Object>(
                      stream: readUsers(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          final users = snapshot.data as List<UserModel>;
                          UserModel? user;
                          if (users.length > 0){
                            user = users.firstWhere((user) => user.uid == Provider.of<User?>(context)?.uid);
                          }
                          return buildGraph(PredictionLineChartWidget(parameter: 'Reducing Sugar', digitsAfterDecimal: 1, dataRef: dataRef, variety: user?.variety,));
                        } else if(snapshot.hasError){
                          print(snapshot.error);
                          return Text('Something went wrong');
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                      }
                    ),
                    Text(
                      'Total Sugar (%w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Total sugar', digitsAfterDecimal: 1, dataRef: dataRef,)),
                    Text(
                      'pH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'pH', digitsAfterDecimal: 1, dataRef: dataRef,)),
                    Text(
                      'Starch (%w/FW)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    buildGraph(PredictionLineChartWidget(parameter: 'Starch', digitsAfterDecimal: 1, dataRef: dataRef,)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGraph(Widget lineChartWidget) {
    return Container(
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
              lineChartWidget,
              // Positioned(
              //     right: 10,
              //     top: 10,
              //     child: Column(
              //       children: [
              //         Text('Legend'),
              //         Text('Predicted data')
              //       ],)
              // )
            ],
          ),),
          Text(
              "           Time (days)",
              style : TextStyle(
                color: Color(0xff75729e),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
          )
        ],
      ),

    );
  }
}
