import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/registration_page.dart';
import 'dropdown_widget.dart';

class DashboardDataTextFields extends StatefulWidget {
  final int index;
  final Function(String) refreshVariety;
  final Function(String) refreshVarietyType;
  const DashboardDataTextFields({Key? key, required this.index, required this.refreshVariety, required this.refreshVarietyType}) : super(key: key);

  @override
  State<DashboardDataTextFields> createState() => _DashboardDataTextFieldsState();
}

class _DashboardDataTextFieldsState extends State<DashboardDataTextFields> {

  final initialWeightController = TextEditingController();
  late String variety;
  late String varietyType;
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
    'None',
    'Cold-sensitive or High-sugar accumulating',
    'Cold-resistant or Low-sugar accumulating',
  ];

  @override
  void dispose() {
    initialWeightController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // initialWeightController.text = _RegistrationPageState.dashboardDataList[widget.index] ?? '';
    });
    return Column(
      children: [
        SizedBox(height: 20.0),
        Text(
          'Dashboard ${widget.index}',
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Text(
              'Initial weight (kg): ', style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),),
            SizedBox(width: 8,),
            Expanded(
              child: TextFormField(
                controller: initialWeightController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter weight (kg)",
                  labelStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Color(0xFFFFFFFF),
                        width: 5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
                // onChanged: (value) => _RegistrationPageState.dashboardDataList[widget.index] = value,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Text('Potato variety: ', style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),),
            SizedBox(width: 8,),
            Expanded(
              child: DropdownWidget(
                  itemList: varietyList,
                  dropdownValue: variety,
                  notifyParent: widget.refreshVariety
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Text(
              'Nature of variety: ', style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),),
            SizedBox(width: 8,),
            Expanded(
              child: DropdownWidget(
                  itemList: varietyTypeList,
                  dropdownValue: varietyType,
                  notifyParent: widget.refreshVarietyType
              ),
            ),
          ],
        ),
      ],
    );
  }
}
