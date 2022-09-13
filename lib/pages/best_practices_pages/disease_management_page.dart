import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';

class DiseaseManagementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiseasePageState();
  }
}

class _DiseasePageState extends State<DiseaseManagementPage> {
  // const _DiseaseManagementPage({Key? key}) : super(key: key);
  Future<String> getImageURL() async {
    final ref =
        FirebaseStorage.instance.ref().child('profile_images/profie_photo.jpg');
    var url = await ref.getDownloadURL();
    return url;
  }

  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  final AuthServices _authService = AuthServices();

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
          title: Text(
            'Disease Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: StreamBuilder<Object>(
                stream: readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data as List<UserModel>;
                    UserModel? user;
                    String food = "Onion";
                    if (users.length > 0) {
                      user = users.firstWhere((user) =>
                          user.uid == Provider.of<User?>(context)?.uid);
                      String? food = user.foodItem;
                      print(user.foodItem);
                    }
                    if (user?.foodItem == 'Potato')
                      return Column(
                        children: [
                          buildCard(
                              'Pink rot',
                              'Soil moisture management, control the amount of inoculum in soil',
                              'High humidity along with poor ventilation',
                              'assets/images/best_practices/disease_management/pink_rot.jpg'),
                          SizedBox(
                            height: 8,
                          ),
                          buildCard(
                              'Late Blight',
                              'Application of fungicide',
                              'Free moisture and cool to moderate temperature',
                              'assets/images/best_practices/disease_management/late_blight.jpg'),
                          SizedBox(
                            height: 8,
                          ),
                          buildCard(
                              'Soft rot',
                              'Harvest tubers at ideal temperatures, eliminate wet area in storage',
                              'Development of water film and anaerobic conditions',
                              'assets/images/best_practices/disease_management/soft_rot.jpg'),
                        ],
                      );
                    else {
                      return Text('Feature Will be Available soon',
                          style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 16,
                              fontWeight: FontWeight.w300));
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Something went wrong');
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget buildCard(
      String diseaseName, String control, String reason, String assetName) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: ExpansionTile(
        title: Text(
          diseaseName,
          style: TextStyle(
              color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w400),
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
              text: TextSpan(children: [
            TextSpan(
              text: 'Control: ',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: control,
              style: TextStyle(
                color: Colors.white70,
              ),
            )
          ])),
          SizedBox(
            height: 8,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'Reason: ',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: reason,
              style: TextStyle(
                color: Colors.white70,
              ),
            )
          ])),
        ],
      ),
    );
  }
}
