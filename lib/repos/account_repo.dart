import 'dart:async';
import 'dart:convert';

import 'package:gramshot/models/account.dart';
import 'package:gramshot/utils/request.dart' as req;

Future<List<Account>> getAccounts() async {
  return await req.withAuth("get", "user/account").then((response) {
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);
      return parsed["data"]["accounts"]
          .map<Account>((json) => Account.fromJson(json))
          .toList();
    }

    return [];
  });
}

Future<bool> storeAccount(Map<String, dynamic> body) async {
  return await req
      .withAuth("post", "user/account/store", body: jsonEncode(body))
      .then((response) {
    print(response.body);
    return response.statusCode == 201;
  });
}

Future<bool> setDefaultAccount(Map<String, dynamic> body) async {
  return await req
      .withAuth("post", "user/account/set_default", body: jsonEncode(body))
      .then((response) {
    print(response.body);
    return response.statusCode == 200;
  });
}

Future<bool> deleteAccount(String id) async {
  return await req.withAuth("post", "user/account/$id/delete").then((response) {
    return response.statusCode == 200;
  });
}
