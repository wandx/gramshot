import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/models/media.dart';
import 'package:gramshot/models/schedule.dart';
import 'package:gramshot/repos/schedule_repo.dart' as scheduleRepo;
import 'package:intl/intl.dart';

class ScheduleList extends StatefulWidget {
  final AppModel model;

  ScheduleList({@required this.model});

  @override
  _ScheduleListState createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;

  @override
  void initState() {
    widget.model.getSchedule().then((_) {
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jadwal Post"),
      ),
      body: _isLoading
          ? _loader()
          : Container(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                    itemCount: widget.model.schedules.length,
                    itemBuilder: (context, idx) {
                      Schedule s = widget.model.schedules[idx];
                      return Dismissible(
                        key: Key(s.id),
                        onDismissed: (dir) async {
                          await scheduleRepo
                              .deleteSchedule(s.id)
                              .then((res) async {
                            await widget.model.getSchedule();
                          });
                        },
                        background: Container(color: Colors.red),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 3.0),
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black)),
                                width: 50.0,
                                height: 50.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      new DateFormat("dd")
                                          .format(s.detailedDate),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      new DateFormat("MMM")
                                          .format(s.detailedDate),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black12,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  padding: EdgeInsets.all(10.0),
//                                height: 200.0,
                                  child: Container(
                                    child: GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 5,
                                      children: s.media
                                          .map<Widget>(
                                            (Media m) => Container(
                                                  padding: EdgeInsets.all(3.0),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/images/default.png",
                                                    image: m.imageUrl,
                                                  ),
                                                ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                onRefresh: () async {
                  await widget.model.getSchedule();
                },
              ),
            ),
    );
  }

  _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
