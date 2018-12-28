import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/screens/root.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Root(model: (new AppModel())));
  });
}
