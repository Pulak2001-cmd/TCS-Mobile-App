import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/generalized_ui_page.dart';
import 'package:flutter_login_ui/pages/onboarding_page.dart';
import 'package:flutter_login_ui/pages/real_time_monitoring_page.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<UserModel>> readUsers() {
      return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
    }

    /// receiving user from provider
    final loggedInUser = Provider.of<User?>(context);

    if(loggedInUser == null){
      return OnBoardingPage();
    } else {
      return RealTimeMonitoringPage();
    }
  }
}
