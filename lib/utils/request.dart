import 'dart:convert';

import 'package:gramshot/config.dart' as config;
import 'package:gramshot/utils/prefs.dart' as prefs;
import 'package:http/http.dart' as http;

String setUrl(String path) {
  return config.baseUrl + "/" + path;
}

Future<http.Response> withAuth(String method, String path, {body}) async {
  String url = setUrl(path);

  if (body != null) {
    body = json.encode(body);
  }

  if (method == "post") {
    return await prefs.getToken().then((String token) async {
      return await http.post(url, body: body, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }).then((http.Response response) => response);
    });
  } else if (method == "delete") {
    return await prefs.getToken().then((String token) async {
      return await http.delete(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }).then((http.Response response) => response);
    });
  }

  return await prefs.getToken().then((String token) async {
    return await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    }).then((http.Response response) => response);
  });
}

Future<http.Response> regular(String method, String path, {body}) async {
  String url = setUrl(path);

  if (method == "post") {
    return await http.post(url, body: body, headers: {
      "Content-Type": "application/json"
    }).then((http.Response response) => response);
  } else if (method == "delete") {
    return await http.delete(url, headers: {
      "Content-Type": "application/json"
    }).then((http.Response response) => response);
  }

  return await http.get(url, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) => response);
}
