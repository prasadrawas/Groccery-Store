import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/screens/get_location.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/welcome_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaceOrderScreen extends StatefulWidget {
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool isLoading = true;
  String area = '';
  double distancelimit = 0, distance;
  int pricelimit = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  getLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('area') == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GetLocationStatus(
                    nav: PlaceOrderScreen(),
                  )));
    } else {
      try {
        getAppData();
        area = pref.getString("area");
        print(pref.get('addressline'));
        double distanceInMeters = Geolocator.distanceBetween(
            19.463164, 75.399541, pref.getDouble('lat'), pref.getDouble('lng'));
        distance = distanceInMeters / 1000;
        Future.delayed(Duration(milliseconds: 1500)).then((value) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  getAppData() async {
    try {
      FirebaseFirestore.instance
          .collection('appdata')
          .doc('data')
          .get()
          .then((DocumentSnapshot) {
        distancelimit = DocumentSnapshot.get('distance').toDouble();
        pricelimit = DocumentSnapshot.get('price');
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Place order',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
        backgroundColor: Color(0xFF202A36),
      ),
      key: _scaffoldkey,
      backgroundColor: Color(0xFF202A36),
      body: isLoading
          ? LoadingScreen()
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.streetView,
                                  color: Color(0xFFF85547),
                                  size: height * 0.024,
                                ),
                                SizedBox(
                                  width: height * 0.015,
                                ),
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Delivery at ',
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: height * 0.021,
                                            ),
                                          ),
                                          TextSpan(
                                            text: area,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: height * 0.021,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: (distance > distancelimit)
                                          ? true
                                          : false,
                                      child: Text(
                                        'Dilivery is not available at your location.',
                                        style: TextStyle(
                                          fontSize: height * 0.015,
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GetLocationStatus(
                                                      nav: PlaceOrderScreen(),
                                                    )));
                                      },
                                      child: Center(
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'OpenSans',
                                            letterSpacing: 1,
                                            fontSize: height * 0.014,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.013),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: height * 0.023,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  color: Color(0xFFF85547),
                                  size: height * 0.025,
                                ),
                                SizedBox(
                                  width: height * 0.013,
                                ),
                                distance > 20
                                    ? Text('Not available',
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          fontSize: height * 0.023,
                                        ))
                                    : Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Delivery ',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: height * 0.023,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Soon',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                  fontSize: height * 0.023,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Items you've added",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontFamily: 'OpenSans',
                            fontSize: height * 0.020),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: CartMenu.names.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(),
                              height: height * 0.10,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            CartMenu.names[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'OpenSans',
                                              fontSize: height * 0.020,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "₹ " +
                                                              CartMenu
                                                                  .price[index]
                                                                  .toString() +
                                                              "  X" +
                                                              CartMenu
                                                                  .quant[index]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                height * 0.018,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height:
                                                              height * 0.035,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          (CartMenu.quant[CartMenu.names.indexOf(CartMenu.names[index])] == 1)
                                                                              ? CartMenu.names.remove(CartMenu.names[index])
                                                                              : CartMenu.quant[CartMenu.names.indexOf(CartMenu.names[index])] -= 1;
                                                                          print(CartMenu
                                                                              .names
                                                                              .length);
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '-',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            height *
                                                                                0.025,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    CartMenu
                                                                        .quant[
                                                                            index]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFFF85547),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          height *
                                                                              0.022,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          CartMenu.quant[CartMenu
                                                                              .names
                                                                              .indexOf(CartMenu.names[index])] += 1;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '+',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            height *
                                                                                0.025,
                                                                      ),
                                                                    ),
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
                                        SizedBox(
                                          height: height * 0.013,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Item Total",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: height * 0.022,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ " + getItemTotal().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: height * 0.022,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.013,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Delivery charges",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: height * 0.022,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ 0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: height * 0.022,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.013,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Grand Total",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: height * 0.022,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ " + (getItemTotal().toString()),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: height * 0.022,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: (distance > distancelimit ||
                                CartMenu.names.length == 0)
                            ? null
                            : () {
                                if (getItemTotal() >= pricelimit) {
                                  print(getItemTotal());
                                  storeOrder();
                                } else {
                                  _showLimitError();
                                }
                              },
                        borderRadius: BorderRadius.circular(18.0),
                        child: Container(
                          height: height * 0.054,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (distance > distancelimit ||
                                    CartMenu.names.length == 0)
                                ? Colors.grey
                                : Color(0xFFF85547),
                          ),
                          child: Center(
                            child: Text(
                              'Place order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.020,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  int getItemTotal() {
    int total = 0;
    for (int i = 0; i < CartMenu.names.length; i++) {
      total += (CartMenu.price[i] * CartMenu.quant[i]);
    }
    return total;
  }

  int getDeliveryCharges() {
    int total = ((getItemTotal() / 100) * 8).toInt();
    return total;
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  _showLimitError() {
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
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.sadTear,
                        color: Color(0xFFF85547),
                        size: 30,
                      ),
                      Text(
                        "Minimum order value is ${pricelimit}.\n Please pick it from our store",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
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
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {});
  }

  storeOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('phone') == null) {
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
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.sadTear,
                          color: Color(0xFFF85547),
                          size: 30,
                        ),
                        Text(
                          "It seems like your haven't register yet.\n Please register before order something.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Ink(
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
                                CartMenu.cartClear();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (route) => false);
                              },
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                ),
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
          barrierDismissible: true,
          barrierLabel: '',
          pageBuilder: (context, animation1, animation2) {});
    } else {
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          try {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
            CollectionReference orders = FirebaseFirestore.instance
                .collection('users')
                .doc(pref.getString('phone'))
                .collection('orders');
            for (int i = 0; i < CartMenu.names.length; i++) {
              await orders.add({
                'name': CartMenu.names[i],
                'price': CartMenu.price[i],
                'quantity': CartMenu.quant[i],
                'image': CartMenu.images[i],
                'total': CartMenu.price[i] * CartMenu.quant[i],
                'datetime': DateTime.now(),
              });
            }
            sendMail(
                pref.getString('email'),
                pref.getString('name'),
                pref.getString('email'),
                pref.getString('phone'),
                pref.getString('addressline'));
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            showGeneralDialog(
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        content: Container(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.check,
                                color: Color(0xFFF85547),
                                size: 30,
                              ),
                              Text(
                                'Your order is placed successfully.\n Thank you for shopping.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Ink(
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
                                      CartMenu.cartClear();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageScreen()),
                                          (route) => false);
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
          } catch (e) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            _showSnackbar(context, 'Unable to place order');
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        _showSnackbar(context, 'No internet connection');
      }
    }
  }

  sendMail(String recipent, String name, String email, String phone,
      String address) async {
    final String _username = 'askhay.rawas.69@gmail.com';
    final String _password = 'Nanjibhai@69';
    String orderDetails =
        '''<h1>Order Details</h1><h2>Total Products : ${CartMenu.names.length}</h2>''';

    orderDetails = orderDetails + getCustomerMessage();

    final smtpServer = gmail(_username, _password);
    final customerMessage = Message()
      ..from = Address(_username, 'Akshay Rawas')
      ..recipients.add(recipent)
      ..subject = 'Your order placed successfully :: 😀 ::'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = orderDetails;

    try {
      final sendReport = await send(customerMessage, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print(e.toString());
    }

    orderDetails = orderDetails + getAdminMessage(name, email, phone, address);

    final adminMessage = Message()
      ..from = Address(_username, 'Akshay Rawas')
      ..recipients.add('rawasakshay6@gmail.com')
      ..subject = 'New order recived :: 😀 ::'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = orderDetails;

    try {
      final sendReport = await send(adminMessage, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print(e.toString());
    }
  }

  getCustomerMessage() {
    String message = '''''';
    for (int i = 0; i < CartMenu.names.length; i++) {
      message = message +
          '''
          <h3>Product name : ${CartMenu.names[i]}</h3>
          <h3>Price : ${CartMenu.price[0]} X ${CartMenu.quant[i]}</h3>
         ------------------------------------------------------
      ''';
    }
    message = message + "<h2>Total : ${getItemTotal()}</h2>";
    return message;
  }

  getAdminMessage(String name, String email, String phone, String address) {
    return "------------------------------------------------------" +
        '''<h2>Customer Details</h2>
    <h3>Name : $name</h3>
    <h3>Email : $email</h3>
    <h3>Phone : $phone</h3>
    <h3>Address : $address</h3>
    ''';
  }
}
