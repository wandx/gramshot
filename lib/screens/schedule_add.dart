import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gramshot/models/account.dart';
import 'package:gramshot/repos/schedule_repo.dart' as scheduleRepo;
import 'package:intl/intl.dart';

class ScheduleAdd extends StatefulWidget {
  final Map<String, bool> mediaMap;
  final List<Account> accounts;

  ScheduleAdd({
    @required this.mediaMap,
    @required this.accounts,
  });

  @override
  ScheduleAddState createState() {
    return new ScheduleAddState();
  }
}

class ScheduleAddState extends State<ScheduleAdd> {
  DateTime _selectedDate;
  List<String> _mediaIds = [];
  List<String> _accountIdKeys = [];
  Map<String, bool> _accountIds;

  List<DropdownMenuItem<int>> _items = [
    DropdownMenuItem(value: 1, child: Text("00:00:00 - 02:00:00")),
    DropdownMenuItem(value: 2, child: Text("02:01:00 - 04:00:00")),
    DropdownMenuItem(value: 3, child: Text("04:01:00 - 06:00:00")),
    DropdownMenuItem(value: 4, child: Text("06:01:00 - 08:00:00")),
    DropdownMenuItem(value: 5, child: Text("08:01:00 - 10:00:00")),
    DropdownMenuItem(value: 6, child: Text("10:01:00 - 12:00:00")),
    DropdownMenuItem(value: 7, child: Text("12:01:00 - 14:00:00")),
    DropdownMenuItem(value: 8, child: Text("14:01:00 - 16:00:00")),
    DropdownMenuItem(value: 9, child: Text("16:01:00 - 18:00:00")),
    DropdownMenuItem(value: 10, child: Text("18:01:00 - 20:00:00")),
    DropdownMenuItem(value: 11, child: Text("20:01:00 - 22:00:00")),
    DropdownMenuItem(value: 12, child: Text("22:01:00 - 23:59:00")),
  ];

  int _selectedItem;

  @override
  void initState() {
    _mediaKeys();
    _selectedDate = DateTime.now();
    _selectedItem = 1;
    _accountMap();
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
          _accountMapKeys();

          Map<String, dynamic> body = {
            "post_date":
                (new DateFormat("yyyy-MM-dd hh:mm:ss").format(_selectedDate)),
            "images": _mediaIds,
            "batch_id": _selectedItem,
            "account_ids": _accountIdKeys,
          };

          print(json.encode(body));
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
              height: MediaQuery.of(context).size.height * 0.60,
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
                    DropdownButton(
                      items: _items,
                      onChanged: (val) {
                        setState(() => _selectedItem = val);
                        print(_selectedItem);
                      },
                      value: _selectedItem,
                      hint: Text("Pilih waktu upload"),
                    ),
                    Container(
                      child: ListView.builder(
                        itemBuilder: (context, idx) {
                          Account a = widget.accounts[idx];
                          return ListTile(
                            title: Text(a.username),
                            trailing: Checkbox(
                                value: _accountIds[a.id],
                                onChanged: (cur) {
                                  setState(() => _accountIds[a.id] = cur);
                                }),
                          );
                        },
                        itemCount: widget.accounts.length,
                      ),
                      height: 200.0,
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
      firstDate: (new DateTime.now()).subtract(Duration(days: 1)),
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

  _accountMap() {
    _accountIds = new HashMap();
    widget.accounts.forEach((Account a) {
      setState(() {
        _accountIds[a.id] = true;
      });
    });
  }

  _accountMapKeys() {
    _accountIds.forEach((k, v) {
      if (v) {
        setState(() {
          _accountIdKeys.add(k);
        });
      }
    });
  }
}
