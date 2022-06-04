import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/result_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class StepperFormWeightPage extends StatefulWidget {
  String selectedParameter;
  StepperFormWeightPage({Key? key, required this.selectedParameter}) : super(key: key);

  @override
  State<StepperFormWeightPage> createState() => _StepperFormWeightPageState();
}

class _StepperFormWeightPageState extends State<StepperFormWeightPage> {

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

  bool isSelected0 = false, isSelected1= false, isSelected2= false;
  int currentStep = 0;
  String? dropdownValue = '';
  List<PotatoData> varietyList = [
    PotatoData(
      variety: 'Kennebec',
      T_ref: 0.00358744,
      k_ref: -0.0099,
      E: 158.8,
      minT: 2,
      maxT: 10,
    ),
    PotatoData(
      variety: 'Toyoshiro',
      T_ref: 0.00354924,
      k_ref: -0.0076,
      E: 133.7,
      minT: 2,
      maxT: 20,
    ),
    PotatoData(
      variety: 'Wuhoon',
      T_ref: 0.00358744,
      k_ref: -0.0097,
      E: 119.1,
      minT: 2,
      maxT: 10,
    ),
    PotatoData(
      variety: 'K Badshah',
      T_ref: 0.00353544,
      k_ref: -0.002998,
      E: 213.5,
      minT: 4,
      maxT: 15,
    ),
    PotatoData(
      variety: 'Onaway',
      T_ref: 0.003510619,
      k_ref: -0.00112,
      E: 270.3,
      minT: 5,
      maxT: 20,
    ),
    PotatoData(
      variety: 'K Lauvkar',
      T_ref: 0.00353544,
      k_ref: -0.003118,
      E: 217.6,
      minT: 4,
      maxT: 15,
    ),
  ];

  PotatoData? selectedVariety;
  double? storageTime = 5;
  double? storageTemp = 5;
  double? currentRS = 50;

  @override
  void initState() {
    super.initState();
    dropdownValue = varietyList[0].variety;
    selectedVariety = varietyList[0];
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
            child: Stepper(
              type: StepperType.horizontal,
              steps: getSteps(),
              onStepTapped: (step) => setState(() => currentStep = step,),
              currentStep: currentStep,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed:details.onStepCancel,
                            child: Text('Back'),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 16,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text('Next'),
                          ),

                        ],
                      ),
                    ],
                  ),
                );
              },
              onStepContinue: (){
                final isLastStep = currentStep == getSteps().length -1;

                if(isLastStep){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter, result: selectedVariety?.getRS(storageTime, storageTemp, currentRS))));
                  print(selectedVariety?.getRS(storageTime, storageTemp, currentRS));
                  //send data to server
                } else{
                  setState(() => currentStep++ );
                }
              },
              onStepCancel: (){
                final isFirstStep = currentStep == 0;

                if(isFirstStep){
                  //do nothing
                } else{
                  setState(() => currentStep-- );
                }
              },
            ),
          ),
          // floatingActionButton: SafeArea(
          //   child: Container(
          //     // margin: EdgeInsets.only(left: 24),
          //     width: MediaQuery.of(context).size.width - 32,
          //     child: Row(
          //       children: [
          //         ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all(
          //               CircleBorder(),
          //             ),
          //             padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
          //           ),
          //           onPressed: (){},
          //           child: Icon(Icons.arrow_back),
          //         ),
          //         Expanded(child: SizedBox()),
          //         ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all(
          //               CircleBorder(),
          //             ),
          //             padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
          //           ),
          //           onPressed: (){},
          //           child: Icon(Icons.arrow_forward),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: currentStep>0 ? StepState.complete : StepState.indexed,
        isActive: currentStep>=0,
        title: Text('Step 1'),
        content: Container(
          // color: Colors.white10,
          child: Column(
            children: [
              ListTile(
                onTap: (){
                  setState(() => isSelected0 = !isSelected0);
                },
                title: Text(
                  'Remaining Shelf Life',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                leading: Checkbox(
                  value: isSelected0,
                  onChanged: (isBool){
                    setState(() => isSelected0 = !isSelected0);
                  },
                ),
              ),
              ListTile(
                onTap: (){
                  setState(() => isSelected1 = !isSelected1);
                },
                title: Text(
                  'Weight Loss trend at particular T and RH',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                leading: Checkbox(
                  value: isSelected1,
                  onChanged: (isBool){
                    setState(() => isSelected1 = !isSelected1);
                  },
                ),
              ),
              ListTile(
                onTap: (){
                  setState(() => isSelected2 = !isSelected2);
                },
                title: Text(
                  'Current Weightloss Percentage',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                leading: Checkbox(
                  value: isSelected2,
                  onChanged: (isBool){
                    setState(() => isSelected2 = !isSelected2);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        state: currentStep>1 ? StepState.complete : StepState.indexed,
        isActive: currentStep>=1,
        title: Text('Step 2'),
        content: Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Enter data',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text('Enter temperature',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text('Enter storage Time (days)',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  isExpanded: true,
                  underline: Container(
                    color: Colors.transparent,
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 0,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      selectedVariety = varietyList.where((element) => element.variety == dropdownValue).first;
                    });
                  },
                  items: varietyList
                      .map<DropdownMenuItem<String>>((PotatoData value) {
                    return DropdownMenuItem<String>(
                      value: value.variety,
                      child: Text(value.variety!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: currentStep>=2,
        title: Text('Step 3'),
        content: Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Enter data',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text('Enter current RS (%)',style: TextStyle(
                    color: Colors.white70,
                  ),),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text('- OR -', style: TextStyle(color: Colors.white70, fontSize: 20),),
              SizedBox(
                height: 24,
              ),
              Container(
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
                  onPressed: () {
                    setState(() {
                      openModal();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ];
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
