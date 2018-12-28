class Credential {
  final String username;
  final String password;

  Credential({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {"username": this.username, "password": this.password};
  }
}
