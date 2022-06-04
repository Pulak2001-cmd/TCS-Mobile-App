import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';

import '../models/user_model.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

  Future readExcel() async {
    ByteData data = await rootBundle.load("assets/excel/RS_model.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    print(excel.tables['CR_day']?.rows[1][1]?.value.runtimeType);
  }

  //Working stream
  Stream<List<User>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()) ;
  }

  //Working future
  Future<List<User>> getData() async{
    List<User> users = [];
    await FirebaseFirestore.instance.collection("Users").get().then((event) {
      for (var doc in event.docs) {
        users.add(User.fromJson(doc.data()));
        print(doc.data().values);
      }
    });
    return users;
  }

  String? name;
  String? crop;

  PotatoData sampleData = PotatoData(variety: 'Kennebec', T_ref: 0.00358744,  k_ref: -0.0099,  E: 158.8,  minT: 2,  maxT: 10,);

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: Text("Tutorial",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: readUsers(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final users = snapshot.data!;

                return ListView(
                  children: users.map(buildListView).toList(),
                );
              } else if(snapshot.hasError){
                return Text('Something went wrong');
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
          // child: Container(
          //   margin: EdgeInsets.all(16),
          //   child: Column(
          //     children: [
          //       TextFormField(
          //         decoration: InputDecoration(
          //           label: Text('Enter name',style: TextStyle(
          //             color: Colors.white54,
          //           ),),
          //           border: OutlineInputBorder(),
          //         ),
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //         onChanged: (value){
          //           setState(() => name = value);
          //         },
          //       ),
          //       SizedBox(height: 8,),
          //       TextFormField(
          //         decoration: InputDecoration(
          //           label: Text('Enter crop',style: TextStyle(
          //             color: Colors.white54,
          //           ),),
          //           border: OutlineInputBorder(),
          //         ),
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //         onChanged: (value){
          //           setState(() => crop = value);
          //         },
          //       ),
          //       FutureBuilder<List<User>>(
          //         future: getData(),
          //         builder: (context, snapshot) {
          //           if(snapshot.hasData){
          //             final users = snapshot.data!;
          //
          //             return ListView(
          //               children: users.map(buildListView).toList(),
          //             );
          //           } else if(snapshot.hasError){
          //             return Text('Something went wrong');
          //           } else {
          //             return Center(child: CircularProgressIndicator(),);
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ),
        // floatingActionButton: ElevatedButton(
        //   child: Icon(Icons.add),
        //   onPressed: (){
        //     // createUser(name!,crop!); //Sends data to database
        //     getData();
        //   },
        // ),
      ),
    );
  }

  Widget buildListView(User user) => Card(
    child: ListTile(
      title: Text(user.name ?? 'User\'s Name'),
      subtitle: Text(user.crop ?? 'User\'s Crop'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(user.temperature.toString()),
          SizedBox(width: 4,),
          Text(user.relativeHumidity.toString()),
          SizedBox(width: 4,),
          Text(user.ethyleneConc.toString()),
          SizedBox(width: 4,),
          Text(user.co2Conc.toString()),
        ],
      ),
    ),
  );

  // Function to create an entry in the Firestore database
  Future createUser(String name, String crop) async{
    final docUser = FirebaseFirestore.instance.collection('test_collection').doc();

    final json = {
      'id': docUser.id,
      'Name': name,
      'Crop': crop,
      'Date Created': DateTime.now(),

    };

    await docUser.set(json);
  }
}
