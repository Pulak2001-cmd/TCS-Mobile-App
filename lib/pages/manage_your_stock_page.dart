import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/crop_status_model.dart';
import '../widgets/bottom_modal_sheet_manage_your_lot.dart';

class ManageYourStockPage extends StatefulWidget {
  const ManageYourStockPage({Key? key}) : super(key: key);

  @override
  State<ManageYourStockPage> createState() => _ManageYourStockPageState();
}

class _ManageYourStockPageState extends State<ManageYourStockPage> {
  XFile? imagePath;
  bool isLoading = false;
  Map<String,dynamic>? shelfLifeAmbient;
  Map<String,dynamic>? shelfLifeColdStorage;

  //Initialize ImagePicker() class
  final ImagePicker _picker = ImagePicker();

  //Function that sends image to backend where CNN model is run and results are fetched
  Future uploadImage(XFile? imagePath) async{
    final request = http.MultipartRequest("POST", Uri.parse('https://tcs-flask-api.herokuapp.com/manage-your-stock'));
    final headers = {
      "Content-type":"multipart/form-data"
    };

    request.files.add(
        http.MultipartFile('image',imagePath!.readAsBytes().asStream(), await imagePath.length(), filename: imagePath.path.split('/').last )
    );

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    var resJSON = await jsonDecode(res.body);
    setState(() => shelfLifeAmbient = resJSON['result']['ambient']);
    setState(() => cropStatusList.last.shelfLifeAmbient = shelfLifeAmbient);
    setState(() => cropStatusList.last.shelfLifeColdStorage = resJSON['result']['cold']);
    shelfLifeColdStorage = resJSON['result']['cold'];
    setState(() => isLoading = false);
  }

  //Function to pick image from gallery
  Future pickImage ({bool isCamera = false}) async{

    //Set isLoading to true to show circular progress indicator
    setState(() => isLoading = true);

    //XFile variable to store selected image path
    isCamera? imagePath = await _picker.pickImage(source: ImageSource.camera): imagePath = await _picker.pickImage(source: ImageSource.gallery);
  }

  List<CropStatus> cropStatusList = [
    CropStatus(image: 'assets/images/potato_PNG421.png', sproutStatus: 'Sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Not diseased', overallHealthStatus: 'Healthy', shelfLifeAmbient: {'lower_limit':10, 'upper_limit': 20}, shelfLifeColdStorage: {'lower_limit':30, 'upper_limit': 35})
  ];

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
        appBar: AppBar(
          title: Text(
          // 'Manage your stock',
          'Shelf Life Prediction',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Text('Tap to see more details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: HexColor('#423F46'),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16,16,16,24),
                  child: Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: cropStatusList.length,
                      itemBuilder: (context, index) {
                          return Card(
                            color: cropStatusList[index].shelfLifeAmbient!['upper_limit'] > 0 ? HexColor('#A5E1AD') : HexColor('#FF5C58'),
                            child: isLoading? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator(),),
                            ) : ListTile(
                              onTap: ()=> showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => buildSheetManageYourLot(context,cropStatusList[index], isSampleImage: index == 0 ? true: false),
                                backgroundColor: Colors.transparent,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: buildBackgroundImage(index),
                                child: cropStatusList[index].image == null? null: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: index == 0 ? Image.asset((cropStatusList[index].image)!) : Image.file(File((cropStatusList[index].image)!),fit: BoxFit.cover,),
                                ),
                              ),
                              title: Text(
                                'Potato',
                                style:TextStyle(
                                  color: HexColor('#423F46'),
                                  fontWeight: FontWeight.bold,
                                ), ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.more_vert),
                                ],
                              ),
                            ),
                          );
                      },
                      // physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(
              colors: [
                HexColor('#FF5F6D'),
                HexColor('#FFC371'),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: FloatingActionButton.extended(
            label: Text('Select Image'),
            icon: Icon(Icons.add_a_photo_rounded),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            onPressed: () async{
              await openModal();
              setState(() {

                if(imagePath != null){
                  print('not null');
                  cropStatusList.add(CropStatus(image: imagePath?.path, sproutStatus: 'Sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Not diseased', overallHealthStatus: 'Healthy', shelfLifeAmbient: shelfLifeAmbient == null ? {'lower_limit':0, 'upper_limit': 0}: shelfLifeAmbient));
                  imagePath = null;
                } else {
                  print('image path is null');
                }
              });
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<dynamic> openModal() {
    return showModalBottomSheet(
        context: context,
        builder: (context){
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera, color: Colors.white,),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    pickImage(isCamera: true);
                    Navigator.pop(context);
                    await uploadImage(imagePath);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Colors.white,),
                  title: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    await pickImage();
                    Navigator.pop(context);
                    await uploadImage(imagePath);
                  },
                )
              ],
            ),
          );
        },
    );
  }

  ImageProvider<Object>? buildBackgroundImage(int index) {
    if(cropStatusList[index].image == null){
      return NetworkImage('https://api.time.com/wp-content/uploads/2020/04/Boss-Turns-Into-Potato.jpg?quality=85&w=1200&h=628&crop=1');
    } else {
      return null;
    }
  }
}