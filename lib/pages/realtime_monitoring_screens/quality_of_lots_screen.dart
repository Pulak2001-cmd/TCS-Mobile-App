import 'package:flutter/material.dart';
import 'package:flutter_login_ui/providers/temp_crop_list_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_login_ui/common/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../../models/crop_status_model.dart';
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
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                      return Container(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: snapshot.data?[0].items.length,
                            itemBuilder: (context, index) {
                              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<CropListProvider>(context,listen: false).addCropStatus(CropStatus(overallHealthStatus: 'Healthy')));
                              return Card(
                                color: Provider.of<CropListProvider>(context).cropStatusList.length != 0 ? Provider.of<CropListProvider>(context).cropStatusList[index].overallHealthStatus=='Healthy' ? HexColor('#A5E1AD') : HexColor('#FF5C58'): Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data?[1][index],),
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
