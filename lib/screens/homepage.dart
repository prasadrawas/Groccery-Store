import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart.dart';
import 'package:food/screens/get_location.dart';
import 'package:food/screens/menu_viewer.dart';
import 'package:food/screens/profile.dart';
import 'package:food/screens/search.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  CollectionReference offers;
  CollectionReference menu;
  Loading loading;
  var locationStatus;
  var cart;

  @override
  void initState() {
    super.initState();
    getLocation();
    //cart = Provider.of<Cart>(context);
  }

  getLocation() async {
    var status = await Permission.camera.status;
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

  Future getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city") == null) {
      await Future.delayed(Duration(seconds: 10));

      showGeneralDialog(
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.sadTear,
                          color: Color(
                            0xFFF85547,
                          ),
                          size: 35,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "It seems you haven't tell us about your location. Please add your location details",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Ink(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(
                              0xFFF85547,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetLocationStatus(
                                          nav: HomePageScreen())),
                                  (route) => false);
                            },
                            child: Center(
                              child: Text(
                                'Add your location',
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
                ),
              ),
            );
          },
          context: context,
          transitionDuration: Duration(milliseconds: 300),
          barrierDismissible: false,
          barrierLabel: '',
          pageBuilder: (context, animation1, animation2) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    offers = FirebaseFirestore.instance.collection('offers');
    menu = FirebaseFirestore.instance.collection('menulist');
    getStatus();
    return Scaffold(
      backgroundColor: Color(0xFF202A36),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/logo.png',
                                    height: heigth * 0.070,
                                    width: heigth * 0.070,
                                  ),
                                  SizedBox(
                                    width: heigth * 0.010,
                                  ),
                                  Text(
                                    'Dattakrupa',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: heigth * 0.030,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  OpenContainer(
                                    closedColor: Color(0xFF202A36),
                                    openColor: Color(0xFF202A36),
                                    closedBuilder: (context, open) {
                                      return IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.search,
                                          color: Colors.white,
                                          size: heigth * 0.024,
                                        ),
                                        onPressed: open,
                                      );
                                    },
                                    openBuilder: (context, open) {
                                      return ChangeNotifierProvider(
                                          create: (context) => Cart(),
                                          child: SearchScreen());
                                    },
                                  ),
                                  SizedBox(
                                    width: heigth * 0.010,
                                  ),
                                  OpenContainer(
                                    closedColor: Color(0xFF202A36),
                                    openColor: Color(0xFF202A36),
                                    closedBuilder: (context, open) {
                                      return IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.cartArrowDown,
                                          color: Colors.white,
                                          size: heigth * 0.024,
                                        ),
                                        onPressed: open,
                                      );
                                    },
                                    openBuilder: (context, open) {
                                      return ProfileScreen();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: heigth * 0.050,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Explore ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: heigth * 0.023,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Store ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1,
                                      color: Color(0xFFF85547),
                                      fontSize: heigth * 0.023,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: heigth * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: heigth * 0.020,
                          ),
                          Container(
                            height: heigth * 0.160,
                            child: StreamBuilder(
                              stream: offers.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  if (mounted)
                                    return FractionallySizedBox(
                                      heightFactor: 0.01,
                                      widthFactor: 0.3,
                                      child: LinearProgressIndicator(),
                                    );
                                }

                                return ListView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: snapshot.data.docs.map((docs) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF202A36),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          docs['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: heigth * 0.050,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Explore ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: heigth * 0.023,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Menu ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1,
                                      color: Color(0xFFF85547),
                                      fontSize: heigth * 0.023,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: heigth * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: heigth * 0.014,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: StreamBuilder(
                        stream: menu.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            if (mounted)
                              return Align(
                                alignment: Alignment.topCenter,
                                child: FractionallySizedBox(
                                  heightFactor: 0.005,
                                  widthFactor: 0.3,
                                  child: LinearProgressIndicator(),
                                ),
                              );
                          }

                          return GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return FractionallySizedBox(
                                child: menuCards(
                                  heigth,
                                  snapshot.data.docs[index]['image'],
                                  snapshot.data.docs[index]['name'],
                                  snapshot.data.docs[index]['price'],
                                  ChangeNotifierProvider(
                                    create: (context) => Cart(),
                                    child: MenuViewerScreen(
                                      category: snapshot
                                          .data.docs[index]['name']
                                          .toLowerCase(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.docs.length,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuCards(
      double height, String image, String title, int price, Object navigator) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: OpenContainer(
        openColor: Color(0xFF202A36),
        closedColor: Color(0xFF202A36),
        closedBuilder: (context, open) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: open,
            // onTap: () {
            //   openWidget
            //   // Navigator.of(context)
            //   //     .push(MaterialPageRoute(builder: (context) => navigator));
            // },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        image,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.0),
                        Colors.black,
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: height * 0.023,
                    ),
                  ),
                ),
                Text(
                  "Starting from ₹ " + price.toString(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'OpenSans',
                    fontSize: height * 0.018,
                  ),
                ),
              ],
            ),
          );
        },
        openBuilder: (context, close) {
          return navigator;
        },
      ),
    );
  }
}
