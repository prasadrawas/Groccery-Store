import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
        backgroundColor: Color(0xFF202A36),
      ),
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Version',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'V1.0',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Developer',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Prasad Rawas',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      letterSpacing: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
