import 'package:flutter/material.dart';
import 'package:flutter_login_ui/widgets/video_player_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

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
          title: Text("Tutorial",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  buildCard(HexColor('#FF5F6D'),HexColor('#FFC371'),'Food Quality Prediction','You can use this feature for in-depth knowledge about a desired quality parameter of a desired food item by providing required input values. It has in-built mathematical and data-base models to estimate quality. ', isVideo: true),
                  SizedBox(height: 16,),
                  buildCard(HexColor('#11998e'),HexColor('#38ef7d'),'Warehouse Management (Realtime Monitoring)','You can use this feature for continuous real time quality monitoring of food stock stored in warehouse/chamber. This includes collecting data of storage conditions through sensors at regular intervals and employing this data and in-built models for estimating different quality parameters of food. It also includes collecting visual data collecting from cameras installed in warehouse for continuous quality inspection.'),
                  SizedBox(height: 16,),
                  buildCard(HexColor('#2193b0'), HexColor('#6dd5ed'),'Shelf Life Prediction (Different applications)','You can use this feature for shelf life prediction of desired food item at ambient as well as cold/storage condition by providing image as input. It has in-built machine learning models for making predictions. '),
                  SizedBox(height: 16,),
                  buildCard(HexColor('#ec008c'), HexColor('#fc6767'),'Best Practices','You can use this feature for detailed information about dos and don’ts of storage of desired food item. This does not require any input from user. It provides typical guidelines for the storage. '),
                  SizedBox(height: 16,),
                  buildCard(HexColor('#c0c0aa'), HexColor('#1cefff'),'Profile','Your account information'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(HexColor color1, HexColor color2, String title, String body, {bool isVideo = false}){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15.0,
        ),],
      ),
      // padding: EdgeInsets.all(16),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent,),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400
            ),
          ),
          initiallyExpanded: false,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          iconColor: Colors.white70,
          collapsedIconColor: Colors.white70,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: EdgeInsets.all(16).copyWith(top: 8),
          children: [
                  Text(body,style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                  isVideo ? VideoPlayerWidget(
                      videoPlayerController: VideoPlayerController.asset('assets/videos/tutorial_page/generalizedUI_tut_video.mp4'),
                      looping: false,
                  ) : SizedBox(),
                ],

        ),
      ),
    );
  }
}
