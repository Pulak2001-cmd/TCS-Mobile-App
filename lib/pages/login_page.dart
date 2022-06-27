import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/services/auth.dart';

import 'forgot_password_page.dart';
import 'generalized_ui_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final AuthServices _authService = AuthServices();

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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: height * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: height * 0.1,
                        color: Colors.white,
                      )
                    ],
                  ), //let's create a common header widget
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // This will be the login form
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello,',
                          textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Log-in now',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: height*0.05),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: TextField(
                                    decoration: ThemeHelper().textInputDecoration(
                                        'User Name', 'Enter your user name'),
                                  ),
                                  // decoration:
                                  //     ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: height*0.04),
                                Container(
                                  child: TextField(
                                    obscureText: true,
                                    decoration: ThemeHelper().textInputDecoration(
                                        'Password', 'Enter your password'),
                                  ),

                                  // decoration:
                                  //     ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: height * 0.025),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey[500]),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
                                    child: Text(
                                      'Log In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    //After successful login we will redirect to home page.
                                    Clipboard.setData(ClipboardData());
                                    HapticFeedback.heavyImpact();
                                    // dynamic result = await _authService.signInAnon();
                                    //
                                    // if(result == null){
                                    //   print('Error');
                                    // } else {
                                    //   print('Sign in anon');
                                    //   print(result.uid.toString());
                                    // }

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GeneralizedUIPage()));
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: "Don\'t have an account? ",
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Sign Up',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrationPage()));
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ])),
                                ),
                              ],
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// previous design with ClipPath

