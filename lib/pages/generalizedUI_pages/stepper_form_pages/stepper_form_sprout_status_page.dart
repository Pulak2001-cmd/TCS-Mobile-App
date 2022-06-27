import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/result_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class StepperFormSproutStatusPage extends StatefulWidget {
  String selectedParameter;
  StepperFormSproutStatusPage({Key? key, required this.selectedParameter}) : super(key: key);

  @override
  State<StepperFormSproutStatusPage> createState() => _StepperFormSproutStatusPageState();
}

class _StepperFormSproutStatusPageState extends State<StepperFormSproutStatusPage> {

  //Initialize ImagePicker() class
  final ImagePicker _picker = ImagePicker();

  //Method to capture photo from camera
  Future capturePhoto () async{
    //XFile variable to store selected image path
    await _picker.pickImage(source: ImageSource.camera);
  }

  //Method to pick image from gallery
  Future pickImage () async{
    //XFile variable to store selected image path
    await _picker.pickImage(source: ImageSource.gallery);
  }
  //STEP1: selection of intents {0: Prediction of RS after a given time, 1: RS trend at a particular T for a given variety}
  bool isSelected0 = false, isSelected1= false, isSelected2= false;

  //STEP2:
  PotatoData? selectedVariety;
  double? storageTime = 5;
  double? storageTemp = 5;

  //STEP3:
  double? currentRS = 50;




  int currentStep = 0;
  String? dropdownValue = '';
  List<PotatoData> varietyList = [
    PotatoData(
      variety: 'Kennebec',
      T_ref_reciprocal: 0.00358744,
      k_ref: -0.0099,
      E: 158.8,
      minT: 2,
      maxT: 10,
    ),
    PotatoData(
      variety: 'Toyoshiro',
      T_ref_reciprocal: 0.00354924,
      k_ref: -0.0076,
      E: 133.7,
      minT: 2,
      maxT: 20,
    ),
    PotatoData(
      variety: 'Wuhoon',
      T_ref_reciprocal: 0.00358744,
      k_ref: -0.0097,
      E: 119.1,
      minT: 2,
      maxT: 10,
    ),
    PotatoData(
      variety: 'K Badshah',
      T_ref_reciprocal: 0.00353544,
      k_ref: -0.002998,
      E: 213.5,
      minT: 4,
      maxT: 15,
    ),
    PotatoData(
      variety: 'Onaway',
      T_ref_reciprocal: 0.003510619,
      k_ref: -0.00112,
      E: 270.3,
      minT: 5,
      maxT: 20,
    ),
    PotatoData(
      variety: 'K Lauvkar',
      T_ref_reciprocal: 0.00353544,
      k_ref: -0.003118,
      E: 217.6,
      minT: 4,
      maxT: 15,
    ),
  ];

  //Initializer
  @override
  void initState() {
    super.initState();
    dropdownValue = varietyList[0].variety; //initialize default variety to first variety
    selectedVariety = varietyList[0]; //initialize selected variety to first variety
  }

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
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Choose parameter',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Theme(
            data: ThemeData(
                primarySwatch: Colors.blueGrey,
                shadowColor: Colors.transparent,
                canvasColor: Colors.transparent,
                colorScheme: ColorScheme.light(
                    primary: Colors.blueGrey
                )
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    "Capture a photo or select an image from galley to know sprout status",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70
                    ),
                ),
              ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter, result: PotatoData.isImageSprouted(null), isSelected0: isSelected0, isSelected1: isSelected1, isSelected2: isSelected2,selectedVariety: selectedVariety, currentRS: currentRS ,)));
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
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
}