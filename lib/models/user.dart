import 'package:gramshot/models/package.dart';

class User {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String description;
  final Package package;

  User({
    this.id,
    this.email,
    this.username,
    this.isActive,
    this.description,
    this.package,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["data"]["user"]["id"],
      email: json["data"]["user"]["email"],
      username: json["data"]["user"]["username"],
      isActive: json["data"]["user"]["is_active"] == 1,
      description: json["description"],
      package: Package.fromJson(json["data"]["package"]),
    );
  }
}
