import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  return await (SharedPreferences.getInstance())
      .then((SharedPreferences p) => p.getString("token") ?? null);
}

Future<Null> setToken(String token) async {
  await (SharedPreferences.getInstance())
      .then((SharedPreferences p) => p.setString("token", token));
}
