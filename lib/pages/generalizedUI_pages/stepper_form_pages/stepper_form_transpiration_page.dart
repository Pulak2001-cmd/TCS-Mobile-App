import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/generalizedUI_pages/result_page.dart';
import 'package:image_picker/image_picker.dart';

class StepperFormTranspirationPage extends StatefulWidget {
   String selectedParameter;

  StepperFormTranspirationPage({Key? key, required this.selectedParameter}) : super(key: key);

  @override
  State<StepperFormTranspirationPage> createState() => _StepperFormTranspirationPageState();
}

class _StepperFormTranspirationPageState extends State<StepperFormTranspirationPage> {

  bool isSelected0 = false, isSelected1= false;
  int currentStep = 0;
  double? rh = 5;
  double? T = 5;

  TextEditingController tController = TextEditingController();
  TextEditingController rhController = TextEditingController();

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
                  print(widget.selectedParameter);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(selectedParameter: widget.selectedParameter, result: PotatoData.getTranspirationRate(T, rh), isSelected0: isSelected0, isSelected1: isSelected1, T: T, rh: rh, )));

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
                  'Effect of T and RH on weight loss rate',
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
                  'Transpiration Rate',
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
                enabled: isSelected1 ? true:false,
                controller: tController,
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
                  setState(() => T = double.tryParse(value));
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                enabled: isSelected1 ? true:false,
                controller: rhController,
                decoration: InputDecoration(
                  label: Text('Enter Relative Humidity',style: TextStyle(
                    color: Colors.white54,
                  ),),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value){
                  setState(() => rh = double.tryParse(value));
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }

}
