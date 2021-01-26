import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/place_order.dart';
import 'package:food/screens/search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<OrdersScreen> {
  bool loading = true;
  String phone = '';

  Future getPhone() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      phone = pref.getString('phone');
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    getPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
        backgroundColor: Color(0xFF202A36),
      ),
      backgroundColor: Color(0xFF202A36),
      body: loading
          ? LoadingScreen()
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(phone)
                          .collection('orders')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: FractionallySizedBox(
                            heightFactor: 0.001,
                            widthFactor: 0.2,
                            child: LinearProgressIndicator(),
                          ));
                        }
                        return ListView(
                          physics: BouncingScrollPhysics(),
                          children: snapshot.data.docs.map((documents) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              height: height * 0.160,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          documents['image'],
                                          fit: BoxFit.fill,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : LinearProgressIndicator();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: height * 0.015,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          documents['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: height * 0.022,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Price : " +
                                                    documents['price']
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: height * 0.016,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                              Text(
                                                "Quantity : " +
                                                    documents['quantity']
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: height * 0.016,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                              Text(
                                                "Total : " +
                                                    documents['total']
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: height * 0.016,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                              Text(
                                                "Date : " +
                                                    documents['datetime']
                                                        .toDate()
                                                        .toString()
                                                        .substring(0, 11),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: height * 0.016,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ],
                                          ),
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
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
