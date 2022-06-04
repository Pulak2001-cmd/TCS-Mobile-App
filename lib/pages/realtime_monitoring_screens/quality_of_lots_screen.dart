import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/crop_status_model.dart';
import '../widgets/bottom_modal_sheet_crop_status.dart';

class QualityOfLotsScreen extends StatefulWidget {
  const QualityOfLotsScreen({Key? key}) : super(key: key);

  @override
  State<QualityOfLotsScreen> createState() => _QualityOfLotsScreenState();
}

class _QualityOfLotsScreenState extends State<QualityOfLotsScreen> {
  List<CropStatus> cropStatusList = [
    CropStatus(image: 'url', sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Not healthy'),
    CropStatus(image: 'url', sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Healthy'),
    CropStatus(image: 'url', sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Healthy'),
    CropStatus(image: 'url', sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Not healthy'),
  ];

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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: HexColor('#423F46'),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16,16,16,24),
                  child: Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: cropStatusList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: cropStatusList[index].overallHealthStatus=='Healthy' ? HexColor('#A5E1AD') : HexColor('#FF5C58'),
                          child: ListTile(
                            onTap: ()=> showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => buildSheetCropStatus(context,cropStatusList[index]),
                              backgroundColor: Colors.transparent,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('https://api.time.com/wp-content/uploads/2020/04/Boss-Turns-Into-Potato.jpg?quality=85&w=1200&h=628&crop=1',
                              ),

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
                          ),
                        );
                      },
                      // physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
