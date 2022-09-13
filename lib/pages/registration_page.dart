import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/widgets/dropdown_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import '../models/potato_data_model.dart';
import '../services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

enum Profile { farmer, storage, wholesaler, retail, transporter, consumer }

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  TextEditingController numDashboardController =
      TextEditingController(text: '1');
  final numberSensor = TextEditingController(text: '0');
  final initialWeightController = TextEditingController();
  static List<Map<String, dynamic>> dashboardDataList = [{}];

  bool checkedValue = false;
  bool checkboxValue = false;
  final AuthServices _authService = AuthServices();

  late PotatoData selectedVariety;
  late String variety;
  late String varietyType;
  late String profile;
  late String endUse;
  late String foodItem;
  late String food_type;
  late List<String> sensorType = [];
  late String facilities;
  late String location = "Pune";
  int profileOption = 1;
  int numDashboard = 1;
  int numSensor = 0;
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

  List<String> profilesList = [
    'Farmer',
    'Warehouse Manager',
    'Wholesaler',
    'Transporter',
    'Retailer',
    'Consumer',
    'Food Expert'
  ];

  List<String> endUseList = [
    'Chips',
    'Domestic use',
    'Starch',
    'Animal feed',
    'Seeds',
    'Fries'
  ];

  List<String> sensortype = [
    'Temperature',
    'Light',
    'Ethylene Gas',
    'CO2 Gas',
    'Humidity'
  ];

  List<String> FoodItems = ['Potato', 'Onion', 'Carrot', 'Strawberry'];
  List<String> FoodItems_Vegatables = ['Potato', 'Onion', 'Carrot'];
  List<String> FoodItems_fruit = ['Banana', 'Mango', 'Strawberry'];
  List<String> FoodItems_Dairy = ['Milk', 'Cheese', 'Ice cream', 'Yogurt'];
  List<String> FoodItems_Meat = ['Pork', 'Chicken', 'Beef'];
  List<String> FoodItems_Arable = ['Wheat', 'Corn'];

  List<String> FoodTypes = ['Vegetables', 'Fruits', 'Dairy', 'Meat', 'Arable'];

  List<String> facilitiesList = ['Ambient', 'Cold storage', 'Both'];

  void refreshVariety(String val) {
    variety = val;
    setState(() => {});
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=Pune&appid=c6c6a3cd9469ef7a7c78e2c5db977a18";

    final response = await http.get(Uri.parse(url));
    print(response.body);
  }

  void refreshVarietyType(String val) {
    varietyType = val;
    setState(() => {});
  }

  void refreshProfile(String val) {
    profile = val;
    print(val);
    if (val == 'Food Expert') {
      profileOption = 0;
      numDashboard = 0;
      numDashboardController = TextEditingController(text: '0');
    } else {
      profileOption = 1;
      numDashboard = 1;
      numDashboardController = TextEditingController(text: '1');
    }
    print(profileOption);
    setState(() => {});
  }

  void refreshEndUse(String val) {
    endUse = val;
    setState(() => {});
  }

  void refreshFoodItem(String val) {
    foodItem = val;
    setState(() => {});
  }

  void refreshFoodType(String val) {
    food_type = val;
    if (val == 'Vegetables') {
      foodItem = FoodItems_Vegatables[0];
      FoodItems = FoodItems_Vegatables;
    } else if (val == 'Fruits') {
      foodItem = FoodItems_fruit[0];
      FoodItems = FoodItems_fruit;
    } else if (val == 'Dairy') {
      foodItem = FoodItems_Dairy[0];
      FoodItems = FoodItems_Dairy;
    } else if (val == 'Meat') {
      foodItem = FoodItems_Meat[0];
      FoodItems = FoodItems_Meat;
    } else if (val == 'Arable') {
      foodItem = FoodItems_Arable[0];
      FoodItems = FoodItems_Arable;
    }
    setState(() => {});
  }

  void refreshSensorType1(String val) {
    sensorType[0] = (val);
    print(sensorType);
    setState(() => {});
  }

  void refreshSensorType2(String val) {
    sensorType[1] = (val);
    print(sensorType);
    setState(() => {});
  }

  void refreshSensorType3(String val) {
    sensorType[2] = (val);
    print(sensorType);
    setState(() => {});
  }

  void refreshSensorType4(String val) {
    sensorType[3] = (val);
    print(sensorType);
    setState(() => {});
  }

  void refreshSensorType5(String val) {
    sensorType[4] = (val);
    print(sensorType);
    setState(() => {});
  }

  void refreshFacilities(String val) {
    facilities = val;
    setState(() => {});
  }

  /// Initializer
  @override
  void initState() {
    super.initState();
    variety = varietyList[0];

    /// initialize default variety to first variety i.e Saturna
    varietyType = varietyTypeList[0];

    /// initialize default varietyType to first varietyType i.e. Cold-sensitive or High-sugar accumulating
    profile = profilesList[0];
    endUse = endUseList[0];
    foodItem = FoodItems[0];
    food_type = FoodTypes[0];
    facilities = facilitiesList[0];
    selectedVariety = PotatoData();
    selectedVariety.initializeWithAllDayData(variety);
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
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
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  height: height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                          child: Image.asset(
                        'assets/images/sign_up.png',
                        width: width / 2.5,
                      ))
                      // Text('Sign Up',
                      //   style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 50, color: Colors.white),),
                    ],
                  ), //let's create a common header widget
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.15,
                            ),
                            Container(
                              child: Text(
                                'Looks like you don\'t have an account',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              child: Text(
                                'Create an account so you can manage your food',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white70),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              child: TextFormField(
                                controller: nameController,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Name', 'Enter your name'),
                                validator: (val) =>
                                    val!.isEmpty ? "Enter your name" : null,
                              ),
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: emailController,
                                decoration: ThemeHelper().textInputDecoration(
                                    "E-mail address", "Enter your email"),
                                keyboardType: TextInputType.emailAddress,
                                validator: (email) {
                                  if (email != null &&
                                      !EmailValidator.validate(email)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration(
                                    "Password", "Enter your password"),
                                validator: (password) {
                                  if (password!.isEmpty &&
                                      password.length < 6) {
                                    return "Enter minimum 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration(
                                    "Confirm password", "Confirm password"),
                                validator: (val) {
                                  if (val!.isEmpty && val.length < 6) {
                                    return "Please enter your password";
                                  }
                                  return null;
                                },
                              ),
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              children: [
                                Text(
                                  'Profile: ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: DropdownWidget(
                                      itemList: profilesList,
                                      dropdownValue: profile,
                                      notifyParent: refreshProfile),
                                ),
                              ],
                            ),
                            // if (profileOption == 1) SizedBox(height: 20.0),
                            // if (profileOption == 1)
                            //   Row(
                            //     children: [
                            //       Text(
                            //         'No. of Sensor Systems: ',
                            //         style: TextStyle(
                            //           color: Colors.white70,
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 8,
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           controller: numberSensor,
                            //           validator: (value) {
                            //             if (value!.isEmpty)
                            //               return 'please enter a value';
                            //             if (int.parse(value) > 5)
                            //               return '0 < value < 5';
                            //             return null;
                            //           },
                            //           onChanged: (value) {
                            //             if (value != '') {
                            //               setState(() =>
                            //                   numSensor = int.parse(value));
                            //               for (int i = 0;
                            //                   i < int.parse(value);
                            //                   i++) {
                            //                 sensorType.add('Temperature');
                            //               }
                            //             }

                            //             // if(value == '') setState(() => numDashboard = 1);
                            //           },
                            //           style: TextStyle(color: Colors.white),
                            //           decoration: InputDecoration(
                            //             labelText: "Enter number",
                            //             labelStyle: TextStyle(
                            //               color: Colors.white54,
                            //             ),
                            //             border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(8)),
                            //               borderSide: BorderSide(
                            //                   color: Color.fromARGB(
                            //                       255, 241, 234, 234),
                            //                   width: 5.0),
                            //             ),
                            //           ),
                            //           keyboardType: TextInputType.number,
                            //           inputFormatters: [
                            //             FilteringTextInputFormatter.digitsOnly,
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // SizedBox(height: 20.0),
                            // for (int i = 0; i < numSensor; i++)
                            //   Row(
                            //     children: [
                            //       SizedBox(height: 20.0),
                            //       Text(
                            //         'Type of Sensor: ',
                            //         style: TextStyle(
                            //           color: Colors.white70,
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 8,
                            //       ),
                            //       if (i == 0)
                            //         Expanded(
                            //           child: DropdownWidget(
                            //               itemList: sensortype,
                            //               dropdownValue: sensorType[i],
                            //               notifyParent: refreshSensorType1),
                            //         )
                            //       else if (i == 1)
                            //         Expanded(
                            //           child: DropdownWidget(
                            //               itemList: sensortype,
                            //               dropdownValue: sensorType[i],
                            //               notifyParent: refreshSensorType2),
                            //         )
                            //       else if (i == 2)
                            //         Expanded(
                            //           child: DropdownWidget(
                            //               itemList: sensortype,
                            //               dropdownValue: sensorType[i],
                            //               notifyParent: refreshSensorType3),
                            //         )
                            //       else if (i == 3)
                            //         Expanded(
                            //           child: DropdownWidget(
                            //               itemList: sensortype,
                            //               dropdownValue: sensorType[i],
                            //               notifyParent: refreshSensorType4),
                            //         )
                            //       else if (i == 4)
                            //         Expanded(
                            //           child: DropdownWidget(
                            //               itemList: sensortype,
                            //               dropdownValue: sensorType[i],
                            //               notifyParent: refreshSensorType5),
                            //         ),
                            //     ],
                            //   ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Text(
                                  'Food Type: ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: DropdownWidget(
                                      itemList: FoodTypes,
                                      dropdownValue: food_type,
                                      notifyParent: refreshFoodType),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Text(
                                  'Food Item: ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: DropdownWidget(
                                      itemList: FoodItems,
                                      dropdownValue: foodItem,
                                      notifyParent: refreshFoodItem),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Text(
                                  'End use: ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: DropdownWidget(
                                      itemList: endUseList,
                                      dropdownValue: endUse,
                                      notifyParent: refreshEndUse),
                                ),
                              ],
                            ),
                            // SizedBox(height: 20.0),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'Facilities: ',
                            //       style: TextStyle(
                            //         color: Colors.white70,
                            //         fontSize: 16,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 8,
                            //     ),
                            //     Expanded(
                            //       child: DropdownWidget(
                            //           itemList: facilitiesList,
                            //           dropdownValue: facilities,
                            //           notifyParent: refreshFacilities),
                            //     ),
                            //   ],
                            // ),
                            //Remove for Food Expert
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Text(
                                  'No. of systems: ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: numDashboardController,
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return 'please enter a value';
                                      if (int.parse(value) > 5)
                                        return '0 < value < 5';
                                      return null;
                                    },
                                    onChanged: (value) {
                                      if (value != '')
                                        setState(() =>
                                            numDashboard = int.parse(value));
                                      // if(value == '') setState(() => numDashboard = 1);
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: "Enter number",
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
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (numDashboard == 0) SizedBox(height: 20.0),
                            if (numDashboard == 0)
                              Row(
                                children: [
                                  Text(
                                    'Location: ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text('Pune',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        )),
                                  ),
                                ],
                              ),
                            Column(
                              children: <Widget>[
                                for (int i = 1; i <= numDashboard; i++)
                                  Column(
                                    children: [
                                      SizedBox(height: 20.0),
                                      Text(
                                        'System $i',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Initial weight (kg): ',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  initialWeightController,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                labelText: "Enter weight (kg)",
                                                labelStyle: TextStyle(
                                                  color: Colors.white54,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFFFFFFF),
                                                      width: 5.0),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      if (foodItem == 'Potato')
                                        Row(
                                          children: [
                                            Text(
                                              'Variety: ',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: DropdownWidget(
                                                  itemList: varietyList,
                                                  dropdownValue: variety,
                                                  notifyParent: refreshVariety),
                                            ),
                                          ],
                                        ),
                                      if (variety == 'None')
                                        SizedBox(height: 20.0),
                                      if (variety == 'None')
                                        Row(
                                          children: [
                                            Text(
                                              'Nature of variety: ',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: DropdownWidget(
                                                  itemList: varietyTypeList,
                                                  dropdownValue: varietyType,
                                                  notifyParent:
                                                      refreshVarietyType),
                                            ),
                                          ],
                                        ),
                                    ],
                                  )
                              ],
                            ),
                            SizedBox(height: height * 0.05),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Sign Up".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  print(dashboardDataList);
                                  if (_formKey.currentState!.validate()) {
                                    User? user = await _authService
                                        .createUserWithEmailAndPassword(
                                      context,
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      name: nameController.text,
                                    );
                                    if (user == null) {
                                    } else {
                                      await createUser(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          uid: user.uid,
                                          variety: variety,
                                          numDashboard: int.parse(
                                              numDashboardController.text
                                                  .trim()),
                                          profile: profile,
                                          varietyType: varietyType,
                                          initialWeight:
                                              initialWeightController.text == ''
                                                  ? 1000
                                                  : double.parse(
                                                      initialWeightController
                                                          .text));
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'User created successfully',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      await Future.delayed(Duration(seconds: 2),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                        );
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              "- OR -",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: FaIcon(
                                    FontAwesomeIcons.googlePlus,
                                    size: 35,
                                    color: HexColor("#EC2D2F"),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog(
                                              "Google Plus",
                                              "You tap on GooglePlus social icon.",
                                              context);
                                        },
                                      );
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 5, color: HexColor("#40ABF0")),
                                      color: HexColor("#40ABF0"),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.twitter,
                                      size: 23,
                                      color: HexColor("#FFFFFF"),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog(
                                              "Twitter",
                                              "You tap on Twitter social icon.",
                                              context);
                                        },
                                      );
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                                GestureDetector(
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 35,
                                    color: HexColor("#3E529C"),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog(
                                              "Facebook",
                                              "You tap on Facebook social icon.",
                                              context);
                                        },
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(color: Colors.white70)),
                                TextSpan(
                                  text: 'Log In',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ])),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildDropdownWidget(
      {required List itemList,
      required String dropdownValue,
      required dynamic setStateFunc}) {
    return Container(
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
        onChanged: (String? newValue) async {
          dropdownValue = newValue!;
          selectedVariety.variety = dropdownValue;
          await selectedVariety.initializeWithAllDayData(dropdownValue);
          setStateFunc();
          setState(() {});
        },
        items: varietyList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Future createUser(
      {required String name,
      required String email,
      required String password,
      required String uid,
      double initialWeight = 1000,
      String crop = 'Potato',
      String profile = "Farmer",
      String endUse = "Chips",
      String variety = "Saturna",
      String varietyType = "None",
      int numDashboard = 2}) async {
    final newUser = FirebaseFirestore.instance.collection('Users').doc(uid);
    final userDataJSON = {
      "uid": uid,
      "Name": name,
      "Email": email,
      "Password": password,
      "Crop": crop,
      "Initial Weight": initialWeight,
      "Start Date": DateTime.now(),
      "Profile": profile,
      "End use": endUse,
      "Variety": variety,
      "Variety Type": varietyType,
      "Dashboards": numDashboard,
      "foodItem": foodItem
    };
    print(userDataJSON);
    //write user data to database collection
    await newUser.set(userDataJSON);
  }
}
