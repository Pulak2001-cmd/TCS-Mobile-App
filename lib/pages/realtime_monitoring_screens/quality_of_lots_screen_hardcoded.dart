import 'package:flutter/material.dart';
import 'package:flutter_login_ui/widgets/bottom_modal_sheet_quality_of_lots.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../models/crop_status_model.dart';
import '../../providers/current_dashboard_provider.dart';
import '../../providers/quality_of_lots_hardcoded_provider.dart';

class QualityOfLotsScreenHardcoded extends StatefulWidget {
  const QualityOfLotsScreenHardcoded({Key? key}) : super(key: key);

  @override
  State<QualityOfLotsScreenHardcoded> createState() =>
      _QualityOfLotsScreenHardcodedState();
}

class _QualityOfLotsScreenHardcodedState
    extends State<QualityOfLotsScreenHardcoded> {
  List<CropStatus> cropStatusList = [
    CropStatus(
        image:
            'https://firebasestorage.googleapis.com/v0/b/tcs-app-affde.appspot.com/o/test%2F1.jpg?alt=media&token=689bf272-1689-4244-b332-9ca063c08064',
        sproutStatus: 'Not Sprouted',
        diseaseStatus: 'Not Diseased',
        weightLossStatus: 'Weight loss < 10%',
        overallHealthStatus: 'Healthy'),
    CropStatus(
        image:
            'https://firebasestorage.googleapis.com/v0/b/tcs-app-affde.appspot.com/o/test%2F2.jpg?alt=media&token=c2a2d3a4-a05a-4114-b7b9-3ecaf553bd20',
        sproutStatus: 'Not Sprouted',
        diseaseStatus: 'Not Diseased',
        weightLossStatus: 'Weight loss < 10%',
        overallHealthStatus: 'Healthy')
  ];

  Future<void> _refresh() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        cropStatusList = [
          CropStatus(
              image:
                  'https://firebasestorage.googleapis.com/v0/b/tcs-app-affde.appspot.com/o/test%2F1.jpg?alt=media&token=689bf272-1689-4244-b332-9ca063c08064',
              sproutStatus: 'Not Sprouted',
              diseaseStatus: 'Not Diseased',
              weightLossStatus: 'Weight loss < 10%',
              overallHealthStatus: 'Healthy'),
          CropStatus(
              image:
                  'https://firebasestorage.googleapis.com/v0/b/tcs-app-affde.appspot.com/o/test%2Fspouted-refrigerator2.jpg?alt=media&token=ec81e02e-27b3-4bb5-bd30-1d1cd220e133',
              sproutStatus: 'Sprouted',
              diseaseStatus: 'Not Diseased',
              weightLossStatus: 'Weight loss < 10%',
              overallHealthStatus: 'Unhealthy')
        ];
      });
      Provider.of<UselessProvider>(context, listen: false)
          .setIsLotsHealthy(false);
    });

    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    double currentDashboard =
        Provider.of<DashboardProvider>(context).currentDashboard;

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
                          style: currentDashboard == 1
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white70),
                                  splashFactory: NoSplash.splashFactory,
                                  elevation: MaterialStateProperty.all(0.0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                )
                              : ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  splashFactory: NoSplash.splashFactory,
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(0.0),
                                ),
                          onPressed: () {
                            Provider.of<DashboardProvider>(context,
                                    listen: false)
                                .setDashboard(1);
                            setState(() {});
                          },
                          child: Text(
                            'System 1',
                            style: TextStyle(color: Colors.white70),
                          )),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: currentDashboard == 2
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white70),
                                  splashFactory: NoSplash.splashFactory,
                                  elevation: MaterialStateProperty.all(0.0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                )
                              : ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  splashFactory: NoSplash.splashFactory,
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(0.0),
                                ),
                          onPressed: () {
                            Provider.of<DashboardProvider>(context,
                                    listen: false)
                                .setDashboard(2);
                            setState(() {});
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
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Top Layers',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Tap to see more details',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Expanded(
                  child: Container(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: cropStatusList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: cropStatusList[index].overallHealthStatus ==
                                'Healthy'
                            ? HexColor('#A5E1AD')
                            : HexColor('#FF5C58'),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(cropStatusList[index].image!),
                          ),
                          title: Text(
                            'Potato (Cam ${index + 1})',
                            style: TextStyle(
                              color: HexColor('#423F46'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.seedling,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.scaleUnbalanced,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Icon(
                                FontAwesomeIcons.virus,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                            ],
                          ),
                          onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => buildSheetQualityOfLots(
                                context,
                                cropStatusList[index],
                                NetworkImage(cropStatusList[index].image!)),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      );
                    },
                    // physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              )),
              SizedBox(
                height: 8,
              ),
              Text(
                'Bottom Layers',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Tap to see more details',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Expanded(
                  child: Container(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: cropStatusList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: cropStatusList[index].overallHealthStatus ==
                                'Healthy'
                            ? HexColor('#A5E1AD')
                            : HexColor('#FF5C58'),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(cropStatusList[index].image!),
                          ),
                          title: Text(
                            'Potato (Cam ${index + 1})',
                            style: TextStyle(
                              color: HexColor('#423F46'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.seedling,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.scaleUnbalanced,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Icon(
                                FontAwesomeIcons.virus,
                                color: HexColor('#423F46'),
                                size: 14,
                              ),
                            ],
                          ),
                          onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => buildSheetQualityOfLots(
                                context,
                                cropStatusList[index],
                                NetworkImage(cropStatusList[index].image!)),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      );
                    },
                    // physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
