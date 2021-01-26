import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/models/menu.dart';
import 'package:food/screens/edit_product.dart';

class ViewProductsScreen extends StatefulWidget {
  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  bool isSearching = false;
  bool query;
  List<Menu> searchResults = [];
  List<Menu> filteredResults = [];

  initiateSearch(String val) async {
    String searchKey = '';
    if (val.length == 0)
      searchResults = [];
    else
      searchKey = val.substring(0, 1).toUpperCase();

    if (searchResults.length == 0 && val.length == 1) {
      await FirebaseFirestore.instance
          .collection('menu')
          .where('searchkey', isEqualTo: searchKey)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((value) {
          searchResults.add(Menu(
            name: value.get('name'),
            image: value.get('image'),
            price: value.get('price').toDouble(),
            rating: value.get('rating').toDouble(),
            id: value.id,
          ));
        });
        if (mounted) {
          setState(() {});
        }
      }).catchError((onError) {
        print("getCloudFirestoreUsers: ERROR");
        print(onError);
      });
    }
    filteredResults = [];
    searchResults.forEach((element) {
      if (element.name.toLowerCase().startsWith(val)) {
        filteredResults.add(element);
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  letterSpacing: 1,
                ),
                onChanged: (val) {
                  query = true;
                  initiateSearch(val);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Here',
                    focusedBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      letterSpacing: 1,
                    )),
              )
            : Text(
                'Products',
                style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
              ),
        actions: [
          IconButton(
            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
            icon: isSearching
                ? FaIcon(
                    FontAwesomeIcons.times,
                    color: Colors.white,
                    size: height * 0.018,
                  )
                : FaIcon(
                    FontAwesomeIcons.search,
                    color: Colors.white,
                    size: height * 0.018,
                  ),
            onPressed: () {
              if (mounted) {
                setState(() {
                  isSearching = !isSearching;
                });
              }
            },
          ),
        ],
        backgroundColor: Color(0xFF202A36),
      ),
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isSearching
                  ? (filteredResults.length == 0 && query == true)
                      ? Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: filteredResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              height: height * 0.170,
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
                                          filteredResults[index].image,
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
                                    width: height * 0.013,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            filteredResults[index].name,
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
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: height * 0.020,
                                                      color: Color(0xFFF85547),
                                                    ),
                                                    SizedBox(
                                                      width: height * 0.008,
                                                    ),
                                                    Text(
                                                      filteredResults[index]
                                                          .rating
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              height * 0.018,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                    Text(
                                                      "/5",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              height * 0.018,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "₹ " +
                                                            filteredResults[
                                                                    index]
                                                                .price
                                                                .toInt()
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              height * 0.020,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          editProduct(
                                                              filteredResults[
                                                                      index]
                                                                  .id);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                letterSpacing:
                                                                    1,
                                                                fontSize:
                                                                    height *
                                                                        0.018,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          deleteProduct(
                                                              filteredResults[
                                                                      index]
                                                                  .id);
                                                          filteredResults.remove(
                                                              filteredResults[
                                                                  index]);
                                                          if (mounted) {
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                letterSpacing:
                                                                    1,
                                                                fontSize:
                                                                    height *
                                                                        0.018,
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
                          },
                        )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('menu')
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
                                    width: height * 0.013,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: height * 0.019,
                                                      color: Color(0xFFF85547),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      documents['rating']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              height * 0.019,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                    Text(
                                                      "/5",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              height * 0.019,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
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
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              height * 0.019,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          editProduct(
                                                              documents.id);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                letterSpacing:
                                                                    1,
                                                                fontSize:
                                                                    height *
                                                                        0.017,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          deleteProduct(
                                                              documents.id);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                letterSpacing:
                                                                    1,
                                                                fontSize:
                                                                    height *
                                                                        0.017,
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
                                    .collection('menu')
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
        MaterialPageRoute(builder: (context) => EditProductScreen(id)));
  }

  @override
  void dispose() {
    super.dispose();
    CartMenu.cartClear();
  }
}
