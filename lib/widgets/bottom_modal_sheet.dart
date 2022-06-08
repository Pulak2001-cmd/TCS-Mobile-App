import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildSheet(ctx) {
  return DraggableScrollableSheet(
    builder: (_,controller) => Container(
      color: Colors.white,
      child: ListView(
          controller: controller,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(ctx).size.width * 0.9,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,),
                  Text('Temperature too high!'),
                  Icon(Icons.cancel_outlined,
                  color: Colors.black38,),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(ctx).size.width * 0.9,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,),
                  Text('Temperature too high!'),
                  Icon(Icons.cancel_outlined,
                    color: Colors.black38,),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(ctx).size.width * 0.9,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,),
                  Text('Temperature too high!'),
                  Icon(Icons.cancel_outlined,
                    color: Colors.black38,),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(ctx).size.width * 0.9,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,),
                  Text('Temperature too high!'),
                  Icon(Icons.cancel_outlined,
                    color: Colors.black38,),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(ctx).size.width * 0.9,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,),
                  Text('Temperature too high!'),
                  Icon(Icons.cancel_outlined,
                    color: Colors.black38,),
                ],
              ),
            ),
          ],
        ),
    ),
  );
}