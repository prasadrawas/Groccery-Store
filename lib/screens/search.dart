import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/models/menu.dart';
import 'package:food/screens/place_order.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = true;
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
      print(searchKey);
      await FirebaseFirestore.instance
          .collection('menu')
          .where('searchkey', isEqualTo: searchKey)
          .get()
          .then((querySnapshot) {
        print("length : " + querySnapshot.docs.length.toString());
        querySnapshot.docs.forEach((value) {
          searchResults.add(Menu(
            name: value.get('name'),
            image: value.get('image'),
            price: value.get('price').toDouble(),
            rating: value.get('rating').toDouble(),
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
            : null,
        actions: [
          IconButton(
            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
            icon: isSearching
                ? FaIcon(
                    FontAwesomeIcons.times,
                    color: Colors.white,
                    size: 16,
                  )
                : FaIcon(
                    FontAwesomeIcons.search,
                    color: Colors.white,
                    size: 16,
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
        child: (filteredResults.length == 0 && query == true)
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
                    height: 120,
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
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  filteredResults[index].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 15,
                                            color: Color(0xFFF85547),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            filteredResults[index]
                                                .rating
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          Text(
                                            "/5",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "₹ " +
                                                    filteredResults[index]
                                                        .price
                                                        .toInt()
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Consumer<Cart>(
                                              builder: (context, data, child) {
                                                return Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 25,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height: 25,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          data.updateCart(
                                                              filteredResults[
                                                                      index]
                                                                  .price
                                                                  .toInt(),
                                                              searchResults[
                                                                      index]
                                                                  .name);
                                                          CartMenu.updateCart(
                                                              filteredResults[
                                                                      index]
                                                                  .price
                                                                  .toInt(),
                                                              searchResults[
                                                                      index]
                                                                  .name,
                                                              searchResults[
                                                                      index]
                                                                  .image);
                                                        },
                                                        color: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: data.names.contains(
                                                                  filteredResults[
                                                                          index]
                                                                      .name)
                                                              ? Text(
                                                                  'ADDED',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        'OpenSans',
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'ADD +',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        'OpenSans',
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
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
              ),
      ),
      floatingActionButton: Consumer<Cart>(
        builder: (context, data, child) {
          return data.itemCount == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 30),
                  height: 45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Color(0xFFF85547),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (context) => Cart(),
                                  child: PlaceOrderScreen())));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.itemCount.toString() + ' ITEM',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹ ' + data.price.toString(),
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Plus taxes',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'View Cart',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FaIcon(
                                FontAwesomeIcons.caretRight,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    CartMenu.cartClear();
    super.dispose();
  }
}
