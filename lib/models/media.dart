class Media {
  final String id;
  final String name;
  final String captions;
  final String imageUrl;

  Media({
    this.id,
    this.name,
    this.captions,
    this.imageUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      name: json["name"],
      captions: json["captions"],
      imageUrl: json["media_url"],
    );
  }
}
