import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/result_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StepperFormReducingSugarPage extends StatefulWidget {
  final String selectedParameter;
  const StepperFormReducingSugarPage({Key? key, required this.selectedParameter}) : super(key: key);

  @override
  State<StepperFormReducingSugarPage> createState() => _StepperFormReducingSugarPageState();
}

class _StepperFormReducingSugarPageState extends State<StepperFormReducingSugarPage> {

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
  late PotatoData selectedVariety;
  double? storageTime;
  double? storageTemp;

  //STEP3:
  double? currentRS;




  int currentStep = 0;
  late String dropdownValue;
  late String dropdownValue2;
  List<String> varietyList = [
    'Saturna',
    'Kennebec',
    'Agria',
    'Toyoshiro',
    'K Chipsona1',
    'K Jyoti',
    'Wu-foon',
    'Norchip',
    'K Chipsona2',
    'Vangodh',
    'Bintje',
    'Simcoe',
    'Onaway',
    'Cardinal',
    'K Badshah',
    'K Lauvkar',
    'None'
  ];

  List<String> varietyTypeList = [
    'Cold-sensitive or High-sugar accumulating',
    'Cold-resistant or Low-sugar accumulating',
  ];

  //Initializer
  @override
  void initState() {
    super.initState();
    dropdownValue = varietyList[0]; //initialize default variety to first variety i.e Saturna
    dropdownValue2 = varietyTypeList[0]; //initialize default varietyType to first varietyType i.e. Cold-sensitive or High-sugar accumulating
    selectedVariety = PotatoData();
    selectedVariety.initializeWithAllDayData(dropdownValue);

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
              onStepContinue: () async {
                final isLastStep = currentStep == getSteps().length -1;


                if(isLastStep || (!isSelected0 && !isSelected1 && currentStep == 1))  {
                  print(selectedVariety.variety);
                  double? result;
                  (!isSelected0 && !isSelected1 && currentStep == 1) ? result = null: result = await selectedVariety.RS_day(storageTime, storageTemp, currentRS);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter,result: result, isSelected0: isSelected0, isSelected1: isSelected1, isSelected2: isSelected2,selectedVariety: selectedVariety, currentRS: currentRS , T: storageTemp,)));
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
                    'Prediction of RS after a given time',
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
                    'RS trend at particular T for given variety',
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
                    'RS trend for a given variety',
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
                (isSelected0 || isSelected1) ? TextField(
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
                ) : SizedBox(),
                SizedBox(
                  height: 8,
                ),

                //Show Textfield only if 'Prediction of RS after a given time' is selected otherwise show an empty SizedBox i.e nothing
                isSelected0 ? TextField(
                  decoration: InputDecoration(
                    label: Text('Enter storage Time (days)',style: TextStyle(
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
                ) : SizedBox(),

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
                    onChanged: (String? newValue) async{

                      dropdownValue = newValue!;
                      selectedVariety.variety = dropdownValue;
                      await selectedVariety.initializeWithAllDayData(dropdownValue);
                      setState(()  {
                        print(selectedVariety.variety);
                      });
                    },
                    items: varietyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                selectedVariety.variety == 'None'? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<String>(
                    value: dropdownValue2,
                    isExpanded: true,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 0,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    onChanged: (String? newValue) async{

                      dropdownValue2 = newValue!;
                      print(dropdownValue2);
                      await selectedVariety.initializeWithAllDayData(dropdownValue,selectedVarietyType: dropdownValue2);
                      setState(()  {
                      });
                    },
                    items: varietyTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep>=2,
          title: Text(
            'Step 3',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          content: Container(
            child: (isSelected0 || isSelected1) ? Column(
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
                  onChanged: (value){
                    setState(() => currentRS = double.tryParse(value) ?? 0);
                  },
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
            ) : Text(
              'Nothing required, go to next step'
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
