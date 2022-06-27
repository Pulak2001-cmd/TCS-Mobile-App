import 'package:flutter/material.dart';

class DiseaseManagementPage extends StatelessWidget {
  const DiseaseManagementPage({Key? key}) : super(key: key);

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
          title: Text('Disease Management',
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
                buildCard('Pink rot', 'Soil moisture management, control the amount of inoculum in soil', 'High humidity along with poor ventilation', 'assets/images/best_practices/disease_management/pink_rot.jpg'),
                SizedBox(height: 8,),
                buildCard('Late Blight', 'Application of fungicide', 'Free moisture and cool to moderate temperature', 'assets/images/best_practices/disease_management/late_blight.jpg'),
                SizedBox(height: 8,),
                buildCard('Soft rot', 'Harvest tubers at ideal temperatures, eliminate wet area in storage', 'Development of water film and anaerobic conditions', 'assets/images/best_practices/disease_management/soft_rot.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String diseaseName, String control, String reason, String assetName){
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: ExpansionTile(
          title: Text(
            diseaseName,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w400
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetName),
          ),
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          iconColor: Colors.white70,
          collapsedIconColor: Colors.white70,
          backgroundColor: Colors.black12,
          collapsedBackgroundColor: Colors.black12,
          childrenPadding: EdgeInsets.all(16).copyWith(top: 8),
          children: [
            RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Control: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: control,
                      style: TextStyle(
                          color: Colors.white70,
                      ),
                    )
                  ]
                )
            ),
            SizedBox(height: 8,),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Reason: ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      TextSpan(
                        text: reason,
                        style: TextStyle(
                            color: Colors.white70,
                        ),
                      )
                    ]
                )
            ),
        ],
        
      ),
    );
  }
}
