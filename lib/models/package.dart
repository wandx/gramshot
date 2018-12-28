class Package {
  final String name;
  final String description;
  final int accountCount;

  Package({
    this.name,
    this.description,
    this.accountCount,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json["name"],
      description: json["description"],
      accountCount: json["account_count"],
    );
  }
}
