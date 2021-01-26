import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/no_internet.dart';
import 'package:food/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  runApp(SplashScreenPage());
}

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmanos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: Home(),
        backgroundColor: Color(0xFF202A36),
        image: Image.asset('assets/icons/splash.png'),
        photoSize: 100.0,
        useLoader: false,
        loadingText: Text(
          'From Prasad',
          style: TextStyle(
              color: Colors.white, fontFamily: 'OpenSans', letterSpacing: 3),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  var status;
  var navigator;
  @override
  void initState() {
    getStatus();
    checkConnection();
    super.initState();
  }

  Future checkConnection() async {
    try {
      var res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        navigator = null;
      }
    } catch (e) {
      navigator = NoInternet();
    }
  }

  Future getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool("loginStatus") == null ? null : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202A36),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(
                'Error',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            );

          if (snapshot.connectionState == ConnectionState.done) {
            return (navigator == null)
                ? ((status == null) ? WelcomeScreen() : HomePageScreen())
                : NoInternet();
          }

          return Center(
            child: Container(
              height: 1,
              width: 80,
              child: LinearProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
