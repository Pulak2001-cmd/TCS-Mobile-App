import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/splash_screen.dart';
import 'package:flutter_login_ui/providers/alert_provider.dart';
import 'package:flutter_login_ui/providers/current_dashboard_provider.dart';
import 'package:flutter_login_ui/providers/quality_of_lots_hardcoded_provider.dart';
// import 'package:flutter_login_ui/providers/delete_this_useless_provider.dart';
import 'package:flutter_login_ui/providers/temp_crop_list_provider.dart';
import 'package:flutter_login_ui/providers/user_provider.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AlertProvider()),
      ChangeNotifierProvider(create: (context) => CropListProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ChangeNotifierProvider(create: (context) => UselessProvider()),
    ],
    child: MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  //original colors used earlier
  // Color _primaryColor = HexColor('#DC54FE');
  // Color _accentColor = HexColor('#8A02AE');

  // TCS colors
  // Color _primaryColor = HexColor('#724694');
  // Color _accentColor = HexColor('#D33580');

  Color _primaryColor = HexColor('#1F1F1F');
  Color _accentColor = HexColor('#3B3841');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TCS app',
        theme: ThemeData(
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: Colors.grey,
          fontFamily: 'Roboto',
        ),
        home: SplashScreen(title: 'TCS app'),
      ),
    );
  }
}

