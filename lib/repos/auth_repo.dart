import 'dart:convert';

import 'package:gramshot/models/credential.dart';
import 'package:gramshot/utils/prefs.dart' as prefs;
import 'package:gramshot/utils/request.dart' as req;

Future<String> login(Credential credential) async {
  return await req
      .regular("post", "auth/login", body: jsonEncode(credential.toJson()))
      .then((response) async {
    if (response.statusCode == 200) {
      print(response.body);
      var parsed = json.decode(response.body);
      await prefs.setToken(parsed["data"]["token"]);
      return parsed["data"]["token"];
    }
    return null;
  });
}

Future<Null> logout() async {
  await req.withAuth("post", "auth/logout").then((response) async {
    await prefs.setToken(null);
  });
}
