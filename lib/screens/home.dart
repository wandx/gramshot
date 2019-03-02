import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/models/media.dart';
import 'package:gramshot/repos/media_repo.dart' as mediaRepo;
import 'package:gramshot/screens/detail_image.dart';
import 'package:gramshot/screens/schedule_add.dart';
import 'package:gramshot/widgets/sidebar.dart';

class Home extends StatefulWidget {
  final AppModel model;

  Home({@required this.model});

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  Map<String, bool> _mediaMap;
  bool _selectionMode = false;
  List<String> _mediaIds = [];

  @override
  void initState() {
    _checkboxPair();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GRAMSHOOT"),
        actions: <Widget>[
          Visibility(
            visible: _selectionMode,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() => _selectionMode = false);
                _checkboxPair();
              },
            ),
          )
        ],
      ),
      drawer: Sidebar(model: widget.model),
      body: RefreshIndicator(
        child: _setContent(context),
        onRefresh: () async {
          await widget.model.getMedia();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _selectionMode,
            child: FloatingActionButton(
              heroTag: "btnDelete",
              onPressed: () async {
                _mediaKeys();
                await mediaRepo.multipleDelete(_mediaIds).then((result) {
                  widget.model.getMedia();
                });
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              mini: true,
            ),
          ),
          FloatingActionButton(
            heroTag: "btnAdd",
            onPressed: () async {
              if (_selectionMode) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new ScheduleAdd(
                          mediaMap: _mediaMap,
                          accounts: widget.model.accounts,
                        ),
                  ),
                ).then((res) {
                  if (res != null && res) {
                    setState(() => _selectionMode = false);
                    _checkboxPair();
                  }
                });
              } else {
                await Navigator.pushNamed(context, "galleryAdd")
                    .then((res) async {
                  if (res != null && res) {
                    await widget.model.getMedia();
                  }
                });
              }
            },
            child: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }

  _setContent(context) {
    if (this.widget.model.media.length > 0) {
      return GridView.count(
        crossAxisCount: 3,
        children: this
            .widget
            .model
            .media
            .map<Widget>(
                (Media m) => _singleGrid(context, m.id, m.imageUrl, m.captions))
            .toList(),
      );
    }
    return ListView(
      children: <Widget>[
        Center(
          child: Text("No Data."),
        ),
      ],
    );
  }

  _singleGrid(context, String i, String image, String captions) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          if (_selectionMode) {
            setState(() => _mediaMap[i] = !_mediaMap[i]);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return DetailImage(imgPath: image, captions: captions);
              }),
            );
          }
        },
        onLongPress: () {
          setState(() => _selectionMode = !_selectionMode);

          if (!_selectionMode) {
            _checkboxPair();
          }
        },
        child: Hero(
          tag: Key(i),
          child: Stack(
            children: <Widget>[
              FadeInImage.assetNetwork(
                placeholder: "assets/images/default.png",
                image: image,
              ),
              Visibility(
                visible: _selectionMode,
                child: Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: Checkbox(
                    value: _mediaMap[i] ?? false,
                    onChanged: (value) {
                      setState(() => _mediaMap[i] = value);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _checkboxPair() {
    _mediaMap = new HashMap();
    widget.model.media.forEach((Media m) {
      setState(() => _mediaMap[m.id] = false);
    });
  }

  _mediaKeys() {
    _mediaMap.forEach((k, v) {
      if (v) {
        setState(() => _mediaIds.add(k));
      }
    });
  }
}
