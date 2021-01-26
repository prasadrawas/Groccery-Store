import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/personal_details_screen.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen({Key key, @required this.phone}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _vericationCode = '';
  FirebaseAuth auth;
  bool isVerifying = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  verifyPhone() async {
    auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (mounted) {
          setState(() {
            isVerifying = true;
          });
        }
        UserCredential result = await auth.signInWithCredential(credential);
        if (result != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  PersonalDetailsScreen(phone: widget.phone)));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          setState(() {
            isVerifying = false;
          });
        }
        _showSnackbar(context, e.code);
      },
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          _vericationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _vericationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  verifyManually(String pin) async {
    if (mounted) {
      setState(() {
        isVerifying = true;
      });
    }
    try {
      var res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        UserCredential result = await auth.signInWithCredential(
            PhoneAuthProvider.credential(
                verificationId: _vericationCode, smsCode: pin));
        if (result != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PersonalDetailsScreen(
                    phone: widget.phone,
                  )));
        }
      }
    } on SocketException catch (e) {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
      _showSnackbar(context, 'No internet connection');
    } catch (e) {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
      _showSnackbar(context, 'Invalid OTP');
    }
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Color(0xFF202A36),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'OTP ',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Colors.white,
                                letterSpacing: 2,
                                fontSize: heigth * 0.032,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Verification',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                letterSpacing: 2,
                                color: Color(0xFFF85547),
                                fontSize: heigth * 0.032,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: heigth * 0.040,
                      ),
                      Center(
                        child: Text(
                          'We have sent a verification code to \n ${widget.phone}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: heigth * 0.022,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: heigth * 0.040,
                      ),
                      Center(
                        child: OTPTextField(
                          length: 6,
                          width: width * 0.90,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: heigth * 0.050,
                          fieldStyle: FieldStyle.box,
                          style: TextStyle(fontSize: 17, color: Colors.white),
                          onCompleted: (pin) async {
                            verifyManually(pin);
                          },
                        ),
                      ),
                      Visibility(
                        visible: isVerifying,
                        child: Container(
                          color: Color(0xFF202A36),
                          child: Center(
                            child: Column(
                              children: [
                                Loading(
                                    indicator: BallPulseIndicator(),
                                    size: heigth * 0.030,
                                    color: Colors.white),
                                Text(
                                  'Verifying number',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: heigth * 0.015,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
