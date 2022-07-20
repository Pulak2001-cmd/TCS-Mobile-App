
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../widgets/header_widget.dart';
import 'onboarding_page.dart';


class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
     return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  double  _drawerIconSize = 24;
  double _drawerFontSize = 17;

  Future<String> getImageURL() async {
    final ref = FirebaseStorage.instance.ref().child('profile_images/profie_photo.jpg');
    var url = await ref.getDownloadURL();
    return url;

  }
  Stream<List<UserModel>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList()) ;
  }

  final AuthServices _authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary,]
              )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),),
            StreamBuilder<Object>(
              stream: readUsers(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  final users = snapshot.data as List<UserModel>;
                  UserModel? user;
                  if (users.length > 0){
                    user = users.firstWhere((user) => user.uid == Provider.of<User?>(context)?.uid);
                  }
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 5, color: Colors.white),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                            ],
                          ),
                          /// Uncomment FutureBuilder if you want to load image from firebase
                          // child: FutureBuilder(
                          //     future: getImageURL(),
                          //     builder: (context, snapshot) {
                          //       if(snapshot.hasData) {
                          //         return CircleAvatar(
                          //           radius: 45,
                          //           backgroundImage: NetworkImage(snapshot.data as String), /// Uses image from firebase
                          //         );
                          //       } else if (snapshot.hasError){
                          //         return Text('Something went wrong');
                          //       } else {
                          //         return CircleAvatar(
                          //             radius: 45,
                          //             child: CircularProgressIndicator()
                          //         );
                          //       }
                          //     }
                          // ),
                          /// Uncomment this if you want profile image icon
                          child: CircleAvatar(
                              radius: 45,
                              child: Icon(
                                Icons.person,
                                size: 45,
                              )
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(user?.name ?? 'Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        SizedBox(height: 8,),
                        Text(Provider.of<User?>(context)?.email ?? 'email', style: TextStyle(fontSize: 16,),),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 8, bottom: 4.0),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "User Information",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 15, vertical: 4),
                                                leading: Icon(Icons.my_location),
                                                title: Text("Potato Variety"),
                                                subtitle: Text(user?.variety ?? 'Variety'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.email),
                                                title: Text("Profile"),
                                                subtitle: Text(user?.profile ?? 'profile'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.phone),
                                                title: Text("Start Date"),
                                                subtitle: Text(DateFormat('dd/MM/yyyy – kk:mm aaa').format(user!.startDate!)),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.person),
                                                title: Text("Initial Weight"),
                                                subtitle: Text(user.initialWeight?.toStringAsFixed(0) ?? 'initial weight'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async{
                            await _authService.signOut();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
                          },
                          child: Text('Sign Out'),
                        )
                      ],
                    ),
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
            )
          ],
        ),
      ),
    );
  }



}

