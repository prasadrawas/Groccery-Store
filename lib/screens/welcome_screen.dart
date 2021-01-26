import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:food/models/cart.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/otp_screen.dart';
import 'package:food/screens/personal_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    Future.delayed(Duration(seconds: 2));
    var status = await Permission.locationWhenInUse.status;
    if (status.isUndetermined) {
      Permission.locationWhenInUse.request();
    }

    if (await Permission.locationWhenInUse.isRestricted) {
      Permission.locationWhenInUse.request();
    }
    if (await Permission.locationWhenInUse.isDenied) {
      Permission.locationWhenInUse.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/logo.png',
                      height: heigth * 0.180,
                    ),
                  ),
                ),
                SizedBox(
                  height: heigth * 0.060,
                ),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Color(
                                0xFFF85547,
                              ),
                              fontSize: heigth * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'to',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: heigth * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.010,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'DattaKrupa ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: heigth * 0.042,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Store',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Color(
                                0xFFF85547,
                              ),
                              fontSize: heigth * 0.042,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: heigth * 0.030,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        height: heigth * 0.058,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                            controller: _controller,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: 17,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              counterText: "",
                              hintStyle: TextStyle(
                                  fontSize: 16, fontFamily: 'OpenSans'),
                              hintText: 'Enter your phone',
                              prefixText: ' +91 ',
                              prefixStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            )),
                      ),
                      SizedBox(
                        height: heigth * 0.060,
                      ),
                      OpenContainer(
                        transitionDuration: Duration(milliseconds: 350),
                        openColor: Color(0xFF202A36),
                        closedColor: Color(0xFF202A36),
                        closedBuilder: (context, open) {
                          return Ink(
                            height: heigth * 0.050,
                            width: width * 0.70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(
                                0xFFF85547,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: open,
                              child: Center(
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: heigth * 0.018,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                        openBuilder: (context, close) {
                          return OTPScreen(phone: '+91' + _controller.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  signingUser(String phone) async {
    if (validatePhoneNumber(phone)) {
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        phone: "+91" + phone,
                      )));
        }
      } catch (e) {
        _showSnackbar(context, 'No internet connection');
      }
    } else {
      _showSnackbar(context, 'Invalid Phone');
    }
  }

  bool validatePhoneNumber(String phone) {
    if (phone.length == 10) {
      String pattern = r'^[7-9]?[0-9]{9}$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(phone)) return true;
    }
    return false;
  }
}
