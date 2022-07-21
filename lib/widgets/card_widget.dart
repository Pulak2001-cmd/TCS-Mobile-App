///////////////////////////
// WIDGET TO BUILD CARDS //
///////////////////////////

import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import '../pages/generalizedUI_pages/choose_stakeholder_page.dart';

Widget buildCard(HexColor color1, HexColor color2, String title,String url, BuildContext context) {
  return Expanded(
    child: Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white10,
            Colors.white10,
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
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChooseStakeholdersPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(url),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}