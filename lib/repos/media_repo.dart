import 'dart:async';
import 'dart:convert';

import 'package:gramshot/models/media.dart';
import 'package:gramshot/utils/request.dart' as req;

Future<List<Media>> getMedia() async {
  return await req.withAuth("get", "user/gallery").then((response) {
    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      return parsed["data"]["media"]
          .map<Media>((json) => Media.fromJson(json))
          .toList();
    }
    return [];
  });
}

Future<Media> getMediaDetail(String id) async {
  return await req.withAuth("get", "user/gallery/$id").then((response) {
    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      return Media.fromJson(parsed["data"]["media"]);
    }
    return null;
  });
}

Future<bool> storeMedia(Map<String, dynamic> body) async {
  return await req
      .withAuth("post", "user/gallery/store", body: json.encode(body))
      .then((response) {
    return response.statusCode == 201;
  });
}

Future<bool> multipleDelete(List<String> ids) async {
  Map<String, dynamic> data = {"ids": ids};

  return await req
      .withAuth("post", "user/gallery/multiple_delete", body: jsonEncode(data))
      .then((response) {
    print(response.body);
    return response.statusCode == 200;
  });
}
