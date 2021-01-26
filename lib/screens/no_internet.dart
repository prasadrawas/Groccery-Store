import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/main.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.exclamationTriangle,
                      size: heigth * 0.070,
                      color: Color(
                        0xFFF85547,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No Connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: heigth * 0.035,
                        letterSpacing: 2,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Oop's it seems you can't connect to our network, Please check your internet connection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: heigth * 0.020,
                        letterSpacing: 2,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Ink(
                  height: heigth * 0.050,
                  width: width * 0.80,
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
                            builder: (context) => Home(),
                          ),
                          (route) => false);
                    },
                    child: Center(
                      child: Text(
                        'Reload Page',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: heigth * 0.018,
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
  }
}
