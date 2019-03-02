import 'dart:async';
import 'dart:convert';

import 'package:gramshot/models/user.dart';
import 'package:gramshot/utils/request.dart' as req;

Future<User> me() async {
  return await req.withAuth("get", "auth/me").then((response) {
    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      return User.fromJson(parsed);
    }
    return null;
  });
}
