import 'dart:convert';

import 'package:gramshot/models/schedule.dart';
import 'package:gramshot/utils/request.dart' as req;

Future<List<Schedule>> getSchedules() async {
  return req.withAuth("get", "user/schedule").then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);
      return parsed["data"]["schedules"]
          .map<Schedule>((json) => Schedule.fromJson(json))
          .toList();
    }
    return [];
  });
}

Future<bool> storeSchedule(Map<String, dynamic> body) async {
  return await req
      .withAuth("post", "user/schedule/store", body: jsonEncode(body))
      .then((response) {
    return response.statusCode == 201;
  });
}

Future<bool> deleteSchedule(String id) async {
  return await req
      .withAuth("post", "user/schedule/$id/delete")
      .then((response) {
    print(response.body);
    return response.statusCode == 200;
  });
}
