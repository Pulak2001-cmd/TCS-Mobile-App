import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';



Widget buildSheetManageYourLot(ctx, cropStatus) {
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
                backgroundImage: NetworkImage(
                  'https://api.time.com/wp-content/uploads/2020/04/Boss-Turns-Into-Potato.jpg?quality=85&w=1200&h=628&crop=1',
                ),
              ),
              SizedBox(height: 30,),
              ListTile(
                leading: Icon(FontAwesomeIcons.seedling,color: Colors.white,),
                title: Text('Shelf life in ambient conditions: 15 days',style:TextStyle(color: Colors.white,)),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.scaleUnbalanced,color: Colors.white,),
                title: Text('Shelf life in storage conditions: 23 days',style:TextStyle(color: Colors.white,)),
              ),
            ],
          ),
        ),
  );
}


