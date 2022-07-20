////////////////////////////////////////////////////////////////////////////////////////////
//////////////// User provider that provides details of logged in user /////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

/// TODO: This provider is not used currently, but this functionality can be completed

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier{
  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
  }

  UserModel? user = UserModel();

  UserProvider({
    this.user
  });

  /// Useless function
  Future init() async{
    print("init run");
    List<UserModel> users = await readUsers().first;
    print(users);
    user = users.first;
    notifyListeners();
  }
}