import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream from Firebase Auth
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  /// sign in anonymously
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  /// sign in with email and pass
  Future signInWithEmailAndPassword(BuildContext context, {required String email, required String password}) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return user;
    } on FirebaseAuthException catch (e){
      final snackBar = SnackBar(content: Text('${e.message}',style: TextStyle(color: Colors.white),), backgroundColor: Colors.redAccent,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }
  /// sign up and registration
  Future<User?> createUserWithEmailAndPassword(BuildContext context, {required String email, required String password, required String name}) async{
    User? user;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
    );
    try{
      user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      user?.updateDisplayName(name);
    } on FirebaseAuthException catch(e){
      print(e.toString());
      /// Snow snackBar with the error
      final snackBar = SnackBar(content: Text('${e.message}', style: TextStyle(color: Colors.white),), backgroundColor: Colors.redAccent,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
    return user;
  }
  /// sign out
  Future signOut() async{
    try{
      await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  /// Delete all users from firebase
  // Future deleteAllUsers()
}