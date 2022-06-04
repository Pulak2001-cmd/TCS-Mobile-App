import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../generalizedUI_pages/choose_stakeholder_page.dart';

class MeatView extends StatelessWidget {
  const MeatView({Key? key}) : super(key: key);

  //MAIN BODY
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      buildCard(
                          HexColor('#FF5F6D'),
                          HexColor('#FFC371'),
                          'Milk',
                          FontAwesomeIcons.cow,
                          context
                      ),
                      SizedBox(width: 16,),
                      buildCard(
                          HexColor('#11998e'),
                          HexColor('#38ef7d'),
                          'Cheese',
                          FontAwesomeIcons.cheese,
                          context
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Row(
                    children: [
                      buildCard(
                          HexColor('#2193b0'),
                          HexColor('#6dd5ed'),
                          'Ice cream',
                          FontAwesomeIcons.iceCream,
                          context
                      ),
                      SizedBox(width: 16,),
                      buildCard(
                          HexColor('#ec008c'),
                          HexColor('#fc6767'),
                          'yoghurt',
                          FontAwesomeIcons.bowlRice,
                          context
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // WIDGET TO BUILD CARDS
  Widget buildCard(HexColor color1, HexColor color2, String title, IconData icon, BuildContext context) {
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
                  child: Icon(icon,size: 50,color: Colors.white,),
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
}

