import 'package:flutter/material.dart';
import 'package:gramshot/models/user.dart';
import 'package:gramshot/repos/user_repo.dart' as user;
import 'package:gramshot/utils/prefs.dart' as prefs;

Future<Map<String, dynamic>> checkAuth() async {
  return await prefs.getToken().then((String token) async {
    bool check = token.isNotEmpty || token != null;
    if (check) {
      return await user.me().then((User user) {
        return {"result": user != null, "user": user};
      });
    }

    return {"result": check, "user": null};
  });
}

Widget loader() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
