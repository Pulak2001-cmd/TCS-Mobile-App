import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/splash_screen.dart';
import 'package:flutter_login_ui/providers/alert_provider.dart';
import 'package:flutter_login_ui/providers/temp_crop_list_provider.dart';
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


  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  //Color _primaryColor= HexColor('#651BD2');
  //Color _accentColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Firebase.initializeApp(),
    //     builder: (context,snapshot) {
    //       if(snapshot.hasError){
    //         return SplashScreen(title: 'Something went wrong',);
    //       }
    //       if(snapshot.connectionState == ConnectionState.done){
    //         return StreamProvider<User?>.value(
    //           initialData: null,
    //           value: AuthServices().user,
    //           child: MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             title: 'Flutter Login UI',
    //             theme: ThemeData(
    //               primaryColor: _primaryColor,
    //               accentColor: _accentColor,
    //               scaffoldBackgroundColor: Colors.grey.shade100,
    //               primarySwatch: Colors.grey,
    //               fontFamily: 'Roboto',
    //             ),
    //             home: SplashScreen(title: 'Flutter Login UI'),
    //           ),
    //         );
    //       }
    //         return MaterialApp(
    //           home: LoginPage(),
    //         );
    //     }
    //   );
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

