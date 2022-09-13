import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/choose_stakeholder_page.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/card_widget.dart';

class VegetablesView extends StatelessWidget {
  const VegetablesView({Key? key}) : super(key: key);

  //MAIN BODY
  @override
  Widget build(BuildContext context) {
    print(context);
    print("hello");
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
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
                          'Onion',
                          'assets/images/generalizedUI_page/vegetables/onion.png',
                          context),
                      SizedBox(
                        width: 16,
                      ),
                      buildCard(
                          HexColor('#ec008c'),
                          HexColor('#fc6767'),
                          'Carrot',
                          'assets/images/generalizedUI_page/vegetables/carrot.png',
                          context),
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
                          'Potato',
                          'assets/images/generalizedUI_page/vegetables/potato.png',
                          context),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(child: SizedBox())
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
