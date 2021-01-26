import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/screens/edit_category.dart';

class Category {}

class ViewCategoryScreen extends StatefulWidget {
  @override
  _ViewCategoryScreenState createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
        backgroundColor: Color(0xFF202A36),
      ),
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('menulist')
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
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : LinearProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: height * 0.013,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      documents['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: height * 0.022,
                                        fontWeight: FontWeight.w600,
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
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "₹ " +
                                                      documents['price']
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: height * 0.019,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    editProduct(documents.id);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 3,
                                                        bottom: 3),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'OpenSans',
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              height * 0.0190,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    deleteProduct(documents.id);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 3,
                                                        bottom: 3),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'OpenSans',
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              height * 0.0190,
                                                        ),
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

  filterResults() {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        );
      },
    );
  }

  deleteProduct(String id) async {
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
                        FontAwesomeIcons.question,
                        color: Color(0xFFF85547),
                        size: 30,
                      ),
                      Text(
                        "Do you really want to delete ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Ink(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFFF85547)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Ink(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFF85547),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFFF85547)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                Navigator.pop(context);
                                await FirebaseFirestore.instance
                                    .collection('menulist')
                                    .doc(id)
                                    .delete();
                              },
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
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
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        context: context,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {});
  }

  editProduct(String id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditCategoryScreen(id)));
  }

  @override
  void dispose() {
    super.dispose();
    CartMenu.cartClear();
  }
}
