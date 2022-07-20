import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/card_widget.dart';
import '../generalizedUI_pages/choose_stakeholder_page.dart';

class ArableView extends StatelessWidget {
  const ArableView({Key? key}) : super(key: key);

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
                          'Wheat',
                          'assets/images/generalizedUI_page/arables/wheat.png',
                          context
                      ),
                      SizedBox(width: 16,),
                      buildCard(
                          HexColor('#11998e'),
                          HexColor('#38ef7d'),
                          'Corn',
                          'assets/images/generalizedUI_page/arables/corn.png',
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
}

