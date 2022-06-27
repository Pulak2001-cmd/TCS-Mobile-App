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
  TextEditingController tController = TextEditingController();
  TextEditingController rhController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController currentWeightlossController = TextEditingController();

  double? rh =5;
  double? T =5;
  double? currentWeightloss =5;
  double? currentWeight;


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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter, T: T, rh: rh, currentWeightloss: currentWeightloss,isSelected0: isSelected0, isSelected1: isSelected1,isSelected2: isSelected2, currentWeight: currentWeight)));
                  //send data to server
                } else if(!isSelected0 && !isSelected1 && currentStep !=1){
                  setState(() => currentStep+=2 );
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
     List <Step> listOfSteps = [
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
              !isSelected0 && !isSelected1 ? Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Nothing required, go to next step',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ) : SizedBox(),
              isSelected0 || isSelected1 ?Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Enter data',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ) : SizedBox(),
              isSelected0 || isSelected1 ? SizedBox(
                height: 24,
              ) : SizedBox(),
              isSelected0 || isSelected1 ? TextField(
                enabled: isSelected1 || isSelected0 ? true:false,
                decoration: InputDecoration(
                  label: Text(
                    'Enter temperature',
                    style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                controller: tController,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value){
                  setState(() => T = double.tryParse(value));
                },
              ) : SizedBox(),
              isSelected0 || isSelected1 ? SizedBox(
                height: 8,
              ) : SizedBox(),
              isSelected0 || isSelected1 ? TextField(
                enabled: isSelected1 || isSelected0 ? true:false,
                decoration: InputDecoration(
                  label: Text('Enter relative humidity',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                controller: rhController,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value){
                  setState(() => rh = double.tryParse(value));
                },
              ) : SizedBox(),
              SizedBox(
                height: 8,
              ),
              isSelected1 ? TextField(
                decoration: InputDecoration(
                  label: Text('Enter current weight (kg)',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                controller: currentWeightController,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value){
                  setState(() => currentWeight = double.tryParse(value));
                },
              ) : SizedBox(),

            ],
          ),
        ),
      ),
      Step(
         isActive: currentStep >= 2,
         title: Text(
           'Step 3',
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
               !isSelected2 ? TextField(
                 decoration: InputDecoration(
                   label: Text('Enter current weightloss (%)', style: TextStyle(
                     color: Colors.white70,
                   ),),
                   border: OutlineInputBorder(),
                 ),
                 controller: currentWeightlossController,
                 style: TextStyle(
                   color: Colors.white,
                 ),
                 onChanged: (value){
                   setState(() => currentWeightloss = double.tryParse(value));
                 },
               ) : SizedBox(),
               !isSelected2 ? SizedBox(
                 height: 24,
               ) : SizedBox(),
               !isSelected2
                   ? Text('- OR -',
                 style: TextStyle(color: Colors.white70, fontSize: 20),)
                   : SizedBox(),
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

     return listOfSteps;
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
