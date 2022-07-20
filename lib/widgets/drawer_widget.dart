import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/about_us_page.dart';
import 'package:flutter_login_ui/pages/best_practices_page.dart';
import 'package:flutter_login_ui/pages/onboarding_page.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../pages/forgot_password_page.dart';
import '../pages/forgot_password_verification_page.dart';
import '../pages/generalized_ui_page.dart';
import '../pages/login_page.dart';
import '../pages/manage_your_stock_page.dart';
import '../pages/real_time_monitoring_page.dart';
import '../pages/registration_page.dart';
import '../pages/splash_screen.dart';
import '../pages/test_page.dart';
import '../pages/tutorial_page.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);


  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
  }

  Future<String> getImageURL() async {
    final ref = FirebaseStorage.instance.ref().child('profile_images/profie_photo.jpg');
    // no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    return url;

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double _drawerIconSize = 24;
    double _drawerFontSize = 17;
    final AuthServices _authService = AuthServices();

    return Drawer(
      child: Container(
        //color: Colors.white,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.0, 1.0],
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.zero,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder<Object>(
                      stream: readUsers(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          final users = snapshot.data as List<UserModel>;
                          UserModel? user;
                          if (users.length > 0){
                            user = users.firstWhere((user) => user.uid == Provider.of<User?>(context)?.uid);
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Uncomment FutureBuilder if you want image from firebase
                              // FutureBuilder(
                              //   future: getImageURL(),
                              //   builder: (context, snapshot) {
                              //     if(snapshot.hasData) {
                              //       return CircleAvatar(
                              //         radius: 40,
                              //         backgroundImage: NetworkImage(snapshot.data as String), /// Uses image from firebase
                              //       );
                              //     } else if (snapshot.hasError){
                              //       return Text('Something went wrong');
                              //     } else {
                              //       return CircleAvatar(
                              //         radius: 40,
                              //         child: Center(
                              //           child: CircularProgressIndicator(),
                              //         ),
                              //       );
                              //     }
                              //   }
                              // ),
                              /// Uncomment this if you want profile image icon
                              CircleAvatar(
                                radius: 40,
                                child: Icon(
                                  Icons.person,
                                  size: 45,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user?.name ?? "User Name",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    user?.email ?? "emailid@gmail.com",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if(snapshot.hasError){
                          print(snapshot.error);
                          return Text('Something went wrong');
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                      }
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.add_chart_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                // 'Realtime Monitoring',
                'Warehouse Management (Realtime Monitoring)',
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RealTimeMonitoringPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.aod_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                // 'Generalized UI',
                'Food Quality Prediction\n(Environment & Time)',
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneralizedUIPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_to_queue_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                // 'Manage your stock',
                '''Shelf Life Prediction \n(Applications & Environment)''',
                maxLines: 2,
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageYourStockPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.assignment_turned_in_rounded ,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Best Practices',
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BestPracticesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.menu_book,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Tutorial',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                  color: Colors.white70,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.addressCard,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'About Us',
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                  color: Colors.white70,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Colors.white70,
                ),
              ),
              onTap: () async{
                await _authService.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
