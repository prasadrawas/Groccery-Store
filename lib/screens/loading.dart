import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF202A36),
          body: Center(
            child: FractionallySizedBox(
              heightFactor: 0.001,
              widthFactor: 0.2,
              child: LinearProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
