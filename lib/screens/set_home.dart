import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/screens/home.dart';
import 'package:gramshot/screens/login.dart';
import 'package:gramshot/screens/splash.dart';

class SetHome extends StatefulWidget {
  final AppModel model;

  SetHome({@required this.model});

  @override
  _SetHomeState createState() => _SetHomeState();
}

class _SetHomeState extends State<SetHome> {
  Future<bool> _checkLogin;

  @override
  void initState() {
    _checkLogin = widget.model.checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLogin,
      builder: (BuildContext context, AsyncSnapshot<bool> s) {
        if (s.connectionState == ConnectionState.done) {
          if (s.hasData) {
            if (s.data) {
              return Home(model: widget.model);
            }
          }
          return Login(model: widget.model);
        } else if (s.connectionState == ConnectionState.none) {
          return Center(
            child: Text("No Connection"),
          );
        } else {
          return Splash();
        }
      },
    );
  }
}
