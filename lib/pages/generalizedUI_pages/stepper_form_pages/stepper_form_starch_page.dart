import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/result_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class StepperFormStarchPage extends StatefulWidget {
  String selectedParameter;
  StepperFormStarchPage({Key? key, required this.selectedParameter}) : super(key: key);

  @override
  State<StepperFormStarchPage> createState() => _StepperFormStarchPageState();
}

class _StepperFormStarchPageState extends State<StepperFormStarchPage> {

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

                if(isLastStep || !isSelected1){
                  print(widget.selectedParameter);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter, isSelected0: isSelected0, isSelected1: isSelected1, isSelected2: isSelected2,selectedVariety: selectedVariety, currentRS: currentRS ,)));
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
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: currentStep>0 ? StepState.complete : StepState.indexed,
        isActive: currentStep>=0,
        title: Text(
          'Step 1',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        content: Container(
          // color: Colors.white10,
          child: Column(
            children: [
              ListTile(
                onTap: (){
                  setState(() => isSelected0 = !isSelected0);
                },
                title: Text(
                  'Effect of T on Starch',
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
                  'Change in Starch at a particular T and RH',
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
            ],
          ),
        ),
      ),
      Step(
        state: currentStep>1 ? StepState.complete : StepState.indexed,
        isActive: currentStep>=1,
        title: Text(
          'Step 2',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
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
                onChanged: (value){
                  setState(() => storageTemp = double.tryParse(value) ?? 0);
                },
              ),
              SizedBox(
                height: 8,
              ),

              //Show Textfield only if 'Prediction of RS after a given time' is selected otherwise show an empty SizedBox i.e nothing
              TextField(
                decoration: InputDecoration(
                  label: Text('Enter relative humidity (%)',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value){
                  setState(() => storageTime = double.tryParse(value) ?? 0);
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }
}