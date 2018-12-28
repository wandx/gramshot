import 'package:meta/meta.dart';

class Account {
  final String id;
  final String username;
  final String password;
  final String description;
  final bool isDefault;

  Account({
    @required this.username,
    this.password,
    this.description,
    this.isDefault,
    @required this.id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json["username"],
      password: json["password"],
      description: json["description"],
      isDefault: json["is_default"] == 1,
      id: json["id"],
    );
  }
}
