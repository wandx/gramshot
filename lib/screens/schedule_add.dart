import 'package:flutter/material.dart';
import 'package:gramshot/repos/schedule_repo.dart' as scheduleRepo;
import 'package:intl/intl.dart';

class ScheduleAdd extends StatefulWidget {
  final Map<String, bool> mediaMap;

  ScheduleAdd({@required this.mediaMap});

  @override
  ScheduleAddState createState() {
    return new ScheduleAddState();
  }
}

class ScheduleAddState extends State<ScheduleAdd> {
  DateTime _selectedDate;
  List<String> _mediaIds = [];

  @override
  void initState() {
    _mediaKeys();
    _selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Jadwal Post"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> body = {
            "post_date":
                (new DateFormat("yyyy-MM-dd hh:mm:ss").format(_selectedDate)),
            "images": _mediaIds,
          };
          await scheduleRepo.storeSchedule(body).then((res) {
            if (res) {
              Navigator.pop(context, true);
            }
          });
        },
        child: Icon(Icons.done),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Visibility(
                      visible: true,
                      child: Text(
                        _formattedDate(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await _selectDate(context);
                      },
                      child: Text("Set Tanggal"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime(2100),
    ).then((picked) {
      if (picked != null && picked != _selectedDate) {
        setState(() => _selectedDate = picked);
      }
    });
  }

  _formattedDate() {
    final f = new DateFormat("dd MMM yyyy");
    return f.format(_selectedDate);
  }

  _mediaKeys() {
    widget.mediaMap.forEach((k, v) {
      if (v) {
        setState(() => _mediaIds.add(k));
      }
    });
  }
}
