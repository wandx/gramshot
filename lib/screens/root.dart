import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/screens/account_add.dart';
import 'package:gramshot/screens/account_list.dart';
import 'package:gramshot/screens/gallery_add.dart';
import 'package:gramshot/screens/home.dart';
import 'package:gramshot/screens/login.dart';
import 'package:gramshot/screens/schedule_list.dart';
import 'package:gramshot/screens/set_home.dart';
import 'package:scoped_model/scoped_model.dart';

class Root extends StatelessWidget {
  final AppModel model;

  Root({@required this.model});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: this.model,
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, m) {
          return MaterialApp(
            title: "Gramshot",
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            routes: {
              "root": (context) => Root(model: m),
              "home": (context) => Home(model: m),
              "login": (context) => Login(model: m),
              "galleryAdd": (context) => GalleryAdd(),
              "accountList": (context) => AccountList(model: m),
              "accountAdd": (context) => AccountAdd(),
              "scheduleList": (context) => ScheduleList(model: m),
            },
            home: SetHome(model: this.model),
          );
        },
      ),
    );
  }
}
