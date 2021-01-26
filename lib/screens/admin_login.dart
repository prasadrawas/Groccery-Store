import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginScreen extends StatefulWidget {
  final String phone;
  AdminLoginScreen({Key key, @required this.phone}) : super(key: key);
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF202A36),
        title: Text(
          'Profile',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
      ),
      key: _scaffoldkey,
      backgroundColor: Color(0xFF202A36),
      body: isProcessing
          ? LoadingScreen()
          : SafeArea(
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
                                    text: 'Admin ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 2,
                                      color: Color(0xFFF85547),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Text(
                                'Enter your login details',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 19,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
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
                                        hintText: 'Enter your email',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                        controller: _passwordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        ),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black54),
                                          hintText: 'Enter your password',
                                          border: InputBorder.none,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Ink(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width - 100,
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
                                          'Login',
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
    );
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  signInUser() async {
    if (_passwordController.text.isNotEmpty &&
        _emailController.text.contains('@')) {
      if (mounted) {
        setState(() {
          isProcessing = true;
        });
      }
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text)
              .then((value) async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setBool('admin', true);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserDashboardScreen()));
          }).catchError((e) {
            if (mounted) {
              setState(() {
                isProcessing = false;
              });
            }
            _showSnackbar(context, e.code);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
          _showSnackbar(context, "No internet connection");
        }
      }
    }
  }
}
