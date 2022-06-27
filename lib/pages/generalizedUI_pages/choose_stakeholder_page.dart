import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/choose_parameters_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class ChooseStakeholdersPage extends StatelessWidget {
  const ChooseStakeholdersPage({Key? key}) : super(key: key);

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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Select your domain',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body:Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: ListView(
                children: [
                  buildListTile('Farmer','assets/images/generalizedUI_page/stakeholders/farmer.jpg',context),
                  buildListTile('Transporter','assets/images/generalizedUI_page/stakeholders/transporter.jpg', context),
                  buildListTile('Storage Facility','assets/images/generalizedUI_page/stakeholders/storage_facility.jpg',context),
                  buildListTile('Wholesaler','assets/images/generalizedUI_page/stakeholders/wholesaler.jpg',context),
                  buildListTile('Retailer','assets/images/generalizedUI_page/stakeholders/retailer.jpg',context),
                  buildListTile('Consumer','assets/images/generalizedUI_page/stakeholders/consumer.jpg',context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  //WIDGET TO BUILD ListTiles()
  Widget buildListTile(String title, String assetName, BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: HexColor('#606060').withOpacity(0.5),
        boxShadow: [BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: Offset(2,2),
        ),],
      ),

      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),

        ),
        onPressed: (){
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetName),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChooseParametersPage()),
            );
          },
        ),
      ),
    );
  }
}

