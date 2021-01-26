import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String phone;
  PersonalDetailsScreen({Key key, @required this.phone}) : super(key: key);
  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isProcessing
        ? LoadingScreen()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: _scaffoldkey,
              backgroundColor: Color(0xFF202A36),
              body: SafeArea(
                child: SingleChildScrollView(
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
                                      text: 'Personal ',
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        fontSize: heigth * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Details',
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        letterSpacing: 2,
                                        color: Color(0xFFF85547),
                                        fontSize: heigth * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: heigth * 0.035,
                              ),
                              Center(
                                child: Text(
                                  'Tell us a bit more about yourself',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: heigth * 0.020,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: heigth * 0.050,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: heigth * 0.060,
                                      padding: EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: _nameController,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        ),
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black54),
                                          hintText: 'Enter your name',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: heigth * 0.030,
                                    ),
                                    Container(
                                      height: heigth * 0.060,
                                      padding: EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                          controller: _emailController,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize: 17,
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                color: Colors.black54),
                                            hintText: 'Enter your email',
                                            border: InputBorder.none,
                                          )),
                                    ),
                                    SizedBox(
                                      height: heigth * 0.050,
                                    ),
                                    Ink(
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
                                        onTap: () {
                                          signInUser();
                                        },
                                        child: Center(
                                          child: Text(
                                            'Continue',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
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
                      ],
                    ),
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

  signInUser() async {
    if (_nameController.text.length >= 2 &&
        _emailController.text.contains('@')) {
      if (mounted) {
        setState(() {
          isProcessing = true;
        });
      }
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          try {
            storeData().then((value) async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              setPrefData(pref).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageScreen()),
                    (route) => false);
              }).catchError((error) {
                if (mounted) {
                  setState(() {
                    isProcessing = false;
                  });
                }
                _showSnackbar(context, 'Unable to store pref data');
              });
            });
          } catch (e) {
            if (mounted) {
              setState(() {
                isProcessing = false;
              });
            }
            _showSnackbar(context, 'Unable to store firestore data');
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
        _showSnackbar(context, 'No internet connection');
      }
    } else {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
      _showSnackbar(context, 'Please enter valid details');
    }
  }

  Future<void> storeData() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.phone).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': widget.phone,
    });
  }

  Future<void> setPrefData(SharedPreferences pref) async {
    pref.setBool("loginStatus", true);
    pref.setString("email", _emailController.text);
    pref.setString("name", _nameController.text);
    pref.setString("phone", widget.phone);
  }
}
