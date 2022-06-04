import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/generalized_ui_page.dart';
import 'package:flutter_login_ui/pages/onboarding_page.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // receiving user from provider
    final user = Provider.of<User?>(context);
    print(user);

    if(user == null){
      return OnBoardingPage();
    } else {
      return GeneralizedUIPage();
    }
    // return OnBoardingPage();
  }
}
