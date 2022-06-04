import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Stream from Firebase Auth
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //sign in anonymously
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

  //sign in with email and pass

  // sign up

  // sign out
  Future signOut() async{
    try{
      await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}