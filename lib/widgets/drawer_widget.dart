import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/about_us_page.dart';
import 'package:flutter_login_ui/pages/best_practices_page.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double _drawerIconSize = 24;
    double _drawerFontSize = 17;

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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Name",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "emailid@gmail.com",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.aod_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Generalized UI',
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
                Icons.add_chart_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Realtime Monitoring',
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
                Icons.add_to_queue_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Manage your stock',
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
                Icons.account_circle_rounded,
                size: _drawerIconSize,
                color: Colors.white70,
              ),
              title: Text(
                'Test',
                style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Colors.white70,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestPage()),
                );
              },
            ),
            SizedBox(
              height: 400,
            ),
            ListTile(
              leading: Icon(
                Icons.screen_lock_landscape_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Splash Screen',
                style: TextStyle(
                    fontSize: 17, color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SplashScreen(title: "Splash Screen")));
              },
            ),
            ListTile(
              leading: Icon(Icons.login_rounded,
                  size: _drawerIconSize, color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Login Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_1,
                  size: _drawerIconSize, color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Registration Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.password_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Forgot Password Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.verified_user_sharp,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Verification Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordVerificationPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
