import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.8),
      child: Center(
        child: Image(
          image: AssetImage("assets/images/icon.png"),
          width: 100.0,
          height: 100.0,
        ),
      ),
    );
  }
}
