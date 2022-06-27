import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/best_practices_pages/disease_management_page.dart';
import 'package:flutter_login_ui/pages/best_practices_pages/quality_standards.dart';
import 'package:flutter_login_ui/pages/best_practices_pages/smart_warehouse.dart';
import 'package:flutter_login_ui/pages/best_practices_pages/storage_protocol.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'best_practices_pages/sprout_management.dart';

class BestPracticesPage extends StatelessWidget {
  BestPracticesPage({Key? key}) : super(key: key);

  final List<ListTileData> listTileData = [
    ListTileData(Icon(FontAwesomeIcons.addressCard), 'Disease Management'),
    ListTileData(Icon(FontAwesomeIcons.addressCard), 'Disease Management'),
    ListTileData(Icon(FontAwesomeIcons.addressCard), 'Disease Management'),
    ListTileData(Icon(FontAwesomeIcons.addressCard), 'Disease Management'),
    ListTileData(Icon(FontAwesomeIcons.addressCard), 'Disease Management'),
  ];



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
          title: Text('Best Practices',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
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
                          'Disease Management',
                          FontAwesomeIcons.briefcaseMedical,
                          DiseaseManagementPage(),
                          context
                      ),
                      SizedBox(width: 16,),
                      buildCard(
                        HexColor('#11998e'),
                        HexColor('#38ef7d'),
                        'Quality Standards',
                        FontAwesomeIcons.heartCircleCheck,
                          QualityStandardsPage(),
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
                        'Sprout Management',
                        FontAwesomeIcons.seedling,
                          SproutManagementPage(),
                          context
                      ),
                      SizedBox(width: 16,),
                      buildCard(
                        HexColor('#ec008c'),
                        HexColor('#fc6767'),
                        'Smart Warehouse',
                        FontAwesomeIcons.houseSignal,
                          SmartWarehousePage(),
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
                        HexColor('#c0c0aa'),
                        HexColor('#1cefff'),
                        'Storage Protocol',
                        FontAwesomeIcons.boxOpen,
                          StorageProtocolPage(),
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

  Widget buildCard(HexColor color1, HexColor color2, String title, IconData icon, page, BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        height: double.infinity,
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
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
                      fontSize:14,
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

  Widget buildListTile(Icon icon, String title) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
      ),
    );
  }
}

class ListTileData {
  Icon leading;
  String title;

  ListTileData(this.leading,this.title);

}
