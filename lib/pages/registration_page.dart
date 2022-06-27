import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'profile_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

enum Profile {farmer,storage,wholesaler,retail,transporter,consumer}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  Profile? _profile = Profile.farmer;


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
                        child: Image.asset('assets/images/sign_up.png',
                          width: width/2.5,)
                    )
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
                            height: height*0.2,
                          ),
                          Container(
                            child: Text('Looks like you don\'t have an account',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 40, color: Colors.white),),
                          ),
                          SizedBox(
                            height: height*0.01,
                          ),
                          Container(
                            child: Text('Create an account so you can manage your warehouse',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white70),),
                          ),
                          SizedBox(
                            height: height*0.03,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: ThemeHelper().textInputDecoration(
                                  'Name', 'Enter your name'),
                            ),
                            // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          // Container(
                          //   child: TextFormField(
                          //     decoration: ThemeHelper().textInputDecoration(
                          //         'Last Name', 'Enter your last name'),
                          //   ),
                          //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          // ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              decoration: ThemeHelper().textInputDecoration(
                                  "E-mail address", "Enter your email"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (!(val!.isEmpty) &&
                                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          // SizedBox(height: 20.0),
                          // Container(
                          //   child: TextFormField(
                          //     decoration: ThemeHelper().textInputDecoration(
                          //         "Mobile Number", "Enter your mobile number"),
                          //     keyboardType: TextInputType.phone,
                          //     validator: (val) {
                          //       if (!(val!.isEmpty) &&
                          //           !RegExp(r"^(\d+)*$").hasMatch(val)) {
                          //         return "Enter a valid phone number";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          //   // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          // ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  "Password", "Enter your password"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                            ),
                            // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  "Confirm password", "Confirm password"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                            ),
                            // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                      title: Text('Farmer'),
                                      leading: Radio(
                                          value: Profile.farmer,
                                          groupValue: _profile,
                                          onChanged: (Profile? value){
                                            setState(() => _profile = value);
                                          }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                  ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text('Storage'),
                                        leading: Radio(
                                            value: Profile.storage,
                                            groupValue: _profile,
                                            onChanged: (Profile? value){
                                              setState(() => _profile = value);
                                            }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Expanded(child: ListTile(
                                    title: Text('Wholesaler'),
                                    leading: Radio(
                                        value: Profile.wholesaler,
                                        groupValue: _profile,
                                        onChanged: (Profile? value){
                                          setState(() => _profile = value);
                                        }),
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  )),
                                  Expanded(child: ListTile(
                                    title: Text('Transporter'),
                                    leading: Radio(
                                        value: Profile.transporter,
                                        groupValue: _profile,
                                        onChanged: (Profile? value){
                                          setState(() => _profile = value);
                                        }),
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  ),)
                                ],),
                                Row(
                                  children: [
                                    Expanded(child: ListTile(
                                      title: Text('Retail'),
                                      leading: Radio(
                                          value: Profile.retail,
                                          groupValue: _profile,
                                          onChanged: (Profile? value){
                                            setState(() => _profile = value);
                                          }),
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                    ),),
                                    Expanded(child: ListTile(
                                      title: Text('Consumer'),
                                      leading: Radio(
                                          value: Profile.consumer,
                                          groupValue: _profile,
                                          onChanged: (Profile? value){
                                            setState(() => _profile = value);
                                          }),
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,

                                    ),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'End use',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text('Farmer'),
                                        leading: Radio(
                                            value: Profile.farmer,
                                            groupValue: _profile,
                                            onChanged: (Profile? value){
                                              setState(() => _profile = value);
                                            }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text('Storage'),
                                        leading: Radio(
                                            value: Profile.storage,
                                            groupValue: _profile,
                                            onChanged: (Profile? value){
                                              setState(() => _profile = value);
                                            }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Expanded(child: ListTile(
                                    title: Text('Wholesaler'),
                                    leading: Radio(
                                        value: Profile.wholesaler,
                                        groupValue: _profile,
                                        onChanged: (Profile? value){
                                          setState(() => _profile = value);
                                        }),
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  )),
                                  Expanded(child: ListTile(
                                    title: Text('Transporter'),
                                    leading: Radio(
                                        value: Profile.transporter,
                                        groupValue: _profile,
                                        onChanged: (Profile? value){
                                          setState(() => _profile = value);
                                        }),
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                  ),)
                                ],),
                                Row(
                                  children: [
                                    Expanded(child: ListTile(
                                      title: Text('Retail'),
                                      leading: Radio(
                                          value: Profile.retail,
                                          groupValue: _profile,
                                          onChanged: (Profile? value){
                                            setState(() => _profile = value);
                                          }),
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                    ),),
                                    Expanded(child: SizedBox(),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Facilities',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text('Farmer'),
                                        leading: Radio(
                                            value: Profile.farmer,
                                            groupValue: _profile,
                                            onChanged: (Profile? value){
                                              setState(() => _profile = value);
                                            }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text('Storage'),
                                        leading: Radio(
                                            value: Profile.storage,
                                            groupValue: _profile,
                                            onChanged: (Profile? value){
                                              setState(() => _profile = value);
                                            }),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: ListTile(
                                      title: Text('Retail'),
                                      leading: Radio(
                                          value: Profile.retail,
                                          groupValue: _profile,
                                          onChanged: (Profile? value){
                                            setState(() => _profile = value);
                                          }),
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                    ),),
                                    Expanded(child: SizedBox(),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height*0.02),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()),
                                          (Route<dynamic> route) => false);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: height*0.03),
                          Text(
                            "- OR -",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: height*0.02),
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
                                width: width*0.1,
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
                                width: width*0.1,
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
                            height: height*0.03,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.white70)),
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
      )
    );

  }
}
