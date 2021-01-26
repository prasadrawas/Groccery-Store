import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/screens/add_category.dart';
import 'package:food/screens/add_products.dart';
import 'package:food/screens/view_category.dart';
import 'package:food/screens/view_products.dart';

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
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
              Text(
                'Choose Action',
                style: TextStyle(
                  fontSize: height * 0.026,
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
                          builder: (context) => AddProductsScreen()));
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
                        'Add Product',
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
                          builder: (context) => AddCategoryScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.cartPlus,
                        color: Colors.white,
                        size: height * 0.025,
                      ),
                      SizedBox(
                        width: height * 0.020,
                      ),
                      Text(
                        'Add Category',
                        style: TextStyle(
                          fontSize: height * 0.025,
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
                          builder: (context) => ViewProductsScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.productHunt,
                        color: Colors.white,
                        size: height * 0.025,
                      ),
                      SizedBox(
                        width: height * 0.020,
                      ),
                      Text(
                        'View Products',
                        style: TextStyle(
                          fontSize: height * 0.025,
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
                          builder: (context) => ViewCategoryScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.luggageCart,
                        color: Colors.white,
                        size: height * 0.025,
                      ),
                      SizedBox(
                        width: height * 0.020,
                      ),
                      Text(
                        'View Category',
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
}
