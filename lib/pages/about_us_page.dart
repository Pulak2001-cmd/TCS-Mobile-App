import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
          title: Text("About Us",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Online Smart Quality Monitoring Solutions to Improve Life of Produce',style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700
                  ),),
                  SizedBox(height: 32,),
                  buildCard('Real Time Quality Monitoring','Assess current and future quality using in-built models'),
                  SizedBox(height: 16,),
                  buildCard('Optimise Storage of Lot','Segregate lot based on quality and store-sell differently'),
                  SizedBox(height: 16,),
                  buildCard('Image Analytics','Detect Visual changes in lot ot get overall health status'),
                  SizedBox(height: 16,),
                  buildCard('Corrective Action Suggestion','Know recommended actions for improving below-par produce quality'),
                  SizedBox(height: 16,),
                  buildCard('Knowledge Centre','Know best practices for most efficient produce handling'),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard( String title, String body) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16)
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(title, style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),),
          SizedBox(height: 8,),
          Text(body,style: TextStyle(
              color: Colors.white54,
              fontSize: 16
          ),),
        ],
      ),
    );
  }
}


