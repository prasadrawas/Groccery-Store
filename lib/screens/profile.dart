import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/screens/about.dart';
import 'package:food/screens/admin_login.dart';
import 'package:food/screens/get_location.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/orders.dart';
import 'package:food/screens/user_dashboard.dart';
import 'package:food/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  bool isUserPresent = false;
  String name = '';
  String phone = '';
  String email = '';

  checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('phone') == null) {
      isUserPresent = false;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      isUserPresent = true;
      phone = pref.getString('phone');
      name = pref.getString('name');
      email = pref.getString('email');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
              ),
              backgroundColor: Color(0xFF202A36),
            ),
            backgroundColor: Color(0xFF202A36),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isUserPresent
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height * 0.180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: height * 0.027,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.013,
                                  ),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: height * 0.020,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.013,
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: height * 0.020,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height * 0.180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your profile',
                                    style: TextStyle(
                                      fontSize: height * 0.028,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.013,
                                  ),
                                  Text(
                                    'Register to view your complete profile.',
                                    style: TextStyle(
                                      fontSize: height * 0.020,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.018,
                                  ),
                                  OpenContainer(
                                    openColor: Color(0xFF202A36),
                                    closedColor: Color(0xFF202A36),
                                    closedBuilder: (context, open) {
                                      return Center(
                                        child: Ink(
                                          height: height * 0.050,
                                          width: width * 0.70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(
                                              0xFFF85547,
                                            ),
                                          ),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: open,
                                            child: Center(
                                              child: Text(
                                                'Register',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    openBuilder: (context, open) {
                                      return WelcomeScreen();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: height * 0.019,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.white70,
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    Text(
                      'Food Orders',
                      style: TextStyle(
                        fontSize: height * 0.025,
                        color: Colors.white70,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clipboardCheck,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                            SizedBox(
                              width: height * 0.020,
                            ),
                            Text(
                              'Your orders',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetLocationStatus()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.addressBook,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                            SizedBox(
                              width: height * 0.020,
                            ),
                            Text(
                              'Address Book',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.info,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                            SizedBox(
                              width: height * 0.020,
                            ),
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    InkWell(
                      onTap: () {
                        loginAdmin();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.userLock,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                            SizedBox(
                              width: height * 0.020,
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  loginAdmin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('admin') == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UserDashboardScreen()));
    }
  }
}
