import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gramshot/config.dart' as config;
import 'package:gramshot/repos/media_repo.dart' as mediaRepo;
import 'package:gramshot/utils/image_process.dart' as imageProcess;
import 'package:gramshot/utils/prefs.dart' as prefs;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class GalleryAdd extends StatefulWidget {
  @override
  GalleryAddState createState() {
    return new GalleryAddState();
  }
}

class GalleryAddState extends State<GalleryAdd> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  String _path = "";
  String _caption = "";
  double _op = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Tambah Gallery"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_path.isEmpty) {
            _showSnackbar("Gambar diperlukan");
            return false;
          }

          if (_caption.isEmpty) {
            _showSnackbar("Captions diperlukan");
            return false;
          }

          await mediaRepo.storeMedia({
            "name": "image",
            "captions": _caption,
            "image": _path
          }).then((success) {
            if (success) {
              Navigator.pop(context, true);
            } else {
              _showSnackbar("Gagal upload gallery");
            }
          });
        },
        child: Icon(Icons.save),
        tooltip: "Simpan",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.pink,
                      width: double.infinity,
                      child: Image(
                        image: _image == null
                            ? AssetImage("assets/images/default.png")
                            : FileImage(_image),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Opacity(
                        opacity: _op,
                        child: Container(
                          color: Colors.white.withOpacity(0.0),
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  _showModal(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Caption"),
                  onChanged: (val) {
                    setState(() => _caption = val);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("Kamera"),
                  leading: Icon(Icons.camera_alt),
                  onTap: () async {
                    await imageProcess.takeImage("camera").then((File f) async {
                      return await imageProcess.cropImage(f, "square");
                    }).then((File f) {
                      setState(() {
                        _image = f;
                        _op = 1.0;
                      });
                      return f;
                    }).then((File f) async {
                      await _uploadImage(f);
                    }).then((_) {
                      setState(() => _op = 0.0);
                    });
                  },
                ),
                ListTile(
                  title: Text("Gallery"),
                  leading: Icon(Icons.image),
                  onTap: () async {
                    await imageProcess
                        .takeImage("gallery")
                        .then((File f) async {
                      return await imageProcess.cropImage(f, "square");
                    }).then((File f) {
                      setState(() {
                        _image = f;
                        _op = 1.0;
                      });
                      return f;
                    }).then((File f) async {
                      await _uploadImage(f);
                    }).then((_) {
                      setState(() => _op = 0.0);
                    });
                  },
                ),
              ],
            ),
          ),
    );
  }

  _uploadImage(File f) async {
    String filename = basename(f.path);
    String ext = filename.split(".").last;

    await prefs.getToken().then((String token) async {
      print(token);
      var request = new http.MultipartRequest(
          "POST", Uri.parse("${config.baseUrl}/user/gallery/uploadMedia"));

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });

      await compute(imageProcess.compress, f.readAsBytesSync()).then((b) {
        var fl = new http.MultipartFile.fromBytes(
          "image",
          b,
          filename: imageProcess.randomString(10, ext),
        );
        request.files.add(fl);
      }).then((_) async {
        return await request.send().then((http.StreamedResponse response) {
          return http.Response.fromStream(response);
        });
      }).then((http.Response response) {
        print(response.body);
        if (response.statusCode == 200) {
          var parsed = json.decode(response.body);
          setState(() => _path = parsed["data"]["path"]);
        }
      });
    });
  }

  _showSnackbar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }
}
