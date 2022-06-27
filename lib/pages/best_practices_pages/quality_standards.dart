import 'package:flutter/material.dart';

class QualityStandardsPage extends StatelessWidget {
  const QualityStandardsPage({Key? key}) : super(key: key);

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
          title: Text('Quality Standards',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildCard('Dehydrated', '>20%', '0.25%', '>13%', '1.080', '>30', '<10%', true),
                  SizedBox(height: 8,),
                  buildCard('French Fries', '>20%', '0.15%', '>13%', '1.080', '>75', '<10%', false),
                  SizedBox(height: 8,),
                  buildCard('Chips', '>20%', '0.1%', '>13%', '>1.080', '45-80', '<10%', false),
                  SizedBox(height: 8,),
                  buildCard('Canned', '<18%', '0.5%', '>13%', '<1.070', '20-35', '<10%', false),
                  SizedBox(height: 8,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String diseaseName, String dryMatter, String rreducingSugar, String starch, String specificGravity, String potatoSize, String weightloss, bool isInitiallyExpanded){
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
          backgroundImage: AssetImage('assets/images/generalizedUI_page/vegetables/potato.png'),
        ),
        initiallyExpanded: isInitiallyExpanded,
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
                      text: 'Dry matter: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: dryMatter,
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
                      text: 'Reducing sugar: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: rreducingSugar,
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
                      text: 'Starch: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: starch,
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
                      text: 'Specific Gravity: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: specificGravity,
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
                      text: 'Potato Size(mm): ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: potatoSize,
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
                      text: 'Weightloss %: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextSpan(
                      text: weightloss,
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
