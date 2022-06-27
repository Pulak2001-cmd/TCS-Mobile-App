import 'dart:io';

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

  //Initialize ImagePicker() class
  final ImagePicker _picker = ImagePicker();

  //Method to capture photo from camera
  Future capturePhoto () async{
    //XFile variable to store selected image path
    imagePath = await _picker.pickImage(source: ImageSource.camera);
  }

  //Method to pick image from gallery
  Future pickImage () async{
    //XFile variable to store selected image path
    imagePath = await _picker.pickImage(source: ImageSource.gallery);
  }

  List<CropStatus> cropStatusList = [
    CropStatus(sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Not healthy', shelfLifeAmbient: 15),
    CropStatus(sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Not healthy', shelfLifeAmbient: -1),
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
          title: Text('Manage your stock',
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
                          color: cropStatusList[index].shelfLifeAmbient! > 0 ? HexColor('#A5E1AD') : HexColor('#FF5C58'),
                          child: ListTile(
                            onTap: ()=> showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => buildSheetManageYourLot(context,cropStatusList[index]),
                              backgroundColor: Colors.transparent,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: buildBackgroundImage(index),
                              child: cropStatusList[index].image == null? null: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(File((cropStatusList[index].image)!),fit: BoxFit.cover,)
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
                cropStatusList.add(CropStatus(image: imagePath?.path, sproutStatus: 'Sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Not diseased', overallHealthStatus: 'Healthy', shelfLifeAmbient: 10));
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
                  onTap: () => capturePhoto(),
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Colors.white,),
                  title: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => pickImage(),
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

// Container(
//   clipBehavior: Clip.antiAlias,
//   decoration: BoxDecoration(
//     color: HexColor('#423F46'),
//     borderRadius: BorderRadius.circular(10),
//   ),
//   width: double.infinity,
//   height: 180,
//   margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//   child: Column(
//     children: [
//       Container(
//         color: HexColor('#3B3841'),
//         width: double.infinity,
//         height: 50,
//         child: Center(
//           child: Text(
//             'Upload image',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       Container(
//         margin: EdgeInsets.fromLTRB(0,16,0,0),
//         child: Icon(Icons.add_a_photo_rounded,
//         size: 30,
//         color: Colors.white54,
//         ),
//       ),
//       Container(
//         margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//         child: TextButton(
//            style: TextButton.styleFrom(
//              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//              backgroundColor: HexColor('#BCD6D4'),
//            ),
//              onPressed: () {
//              setState(() {
//                cropStatusList.add(CropStatus(image: 'url', sproutStatus: 'sprouted', weightLossStatus: 'Weight loss more than critical limit', diseaseStatus: 'Diseased', overallHealthStatus: 'Healthy'));
//              });
//              },
//              child: Text(
//                'Pick image',
//                style: TextStyle(
//                  color: HexColor('#423F46'),
//                  fontWeight: FontWeight.bold,
//                  fontSize: 16,
//                ),
//              ),
//          ),
//       ),
//     ],
//   ),
// ),