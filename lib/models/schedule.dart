import 'package:gramshot/models/media.dart';

class Schedule {
//  final Account account;
  final List<Media> media;
  final String postDate;
  final DateTime detailedDate;
  final String status;
  final String id;

  Schedule({
//    this.account,
    this.media,
    this.postDate,
    this.status,
    this.detailedDate,
    this.id,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
//      account: Account.fromJson(json["account"]),
      media: json["media"].map<Media>((m) => Media.fromJson(m)).toList(),
      postDate: json["post_date"],
      status: json["status"],
      detailedDate: DateTime(
        int.parse(json["detailed_date"]["year"]),
        int.parse(json["detailed_date"]["month"]),
        int.parse(json["detailed_date"]["day"]),
      ),
      id: json["id"],
    );
  }
}
