import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import '../models/crop_status_model.dart';
import 'dart:io';




Widget buildSheetManageYourLot(ctx, CropStatus cropStatus, { bool isSampleImage = false}) {
  Map<String,dynamic>? shelfLifeAmbient = cropStatus.shelfLifeAmbient;
  Map<String, dynamic>? shelfLifeCold = cropStatus.shelfLifeColdStorage;

  if(shelfLifeAmbient == null){
    cropStatus.shelfLifeAmbient = {
      'lower_limit': 0,
      'upper_limit': 0
    };
  }
  if(shelfLifeCold == null){
    cropStatus.shelfLifeColdStorage = {
      'lower_limit': 0,
      'upper_limit': 0
    };
  }

  ImageProvider<Object>? buildBackgroundImage(CropStatus cropStatus) {
      return NetworkImage('https://api.time.com/wp-content/uploads/2020/04/Boss-Turns-Into-Potato.jpg?quality=85&w=1200&h=628&crop=1');
  }
  return DraggableScrollableSheet(
    builder: (_, controller) =>
        Container(
          color: HexColor('#423F46'),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: isSampleImage ? AssetImage(cropStatus.image!) : cropStatus.image == null? buildBackgroundImage(cropStatus) : FileImage(File((cropStatus.image)!)),
              ),
              SizedBox(height: 30,),
              ListTile(
                leading: Icon(FontAwesomeIcons.seedling,color: Colors.white,),
                title: Text('Shelf life in ambient conditions: ${cropStatus.shelfLifeAmbient!['lower_limit']} - ${cropStatus.shelfLifeAmbient!['upper_limit']} days',style:TextStyle(color: Colors.white,)),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.scaleUnbalanced,color: Colors.white,),
                title: Text('Shelf life in cold storage conditions: ${cropStatus.shelfLifeColdStorage!['lower_limit']} - ${cropStatus.shelfLifeColdStorage!['upper_limit']} days',style:TextStyle(color: Colors.white,)),
              ),
            ],
          ),
        ),
  );


}


