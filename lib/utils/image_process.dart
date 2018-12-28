import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File> takeImage(String source) async {
  ImageSource imSource =
      source == "camera" ? ImageSource.camera : ImageSource.gallery;
  return await ImagePicker.pickImage(source: imSource);
}

Future<File> cropImage(File img, String orientation) async {
  double x;
  double y;
  int maxX;
  int maxY;
  switch (orientation) {
    case "potrait":
      x = 4.0;
      y = 5.0;
      maxX = 1080;
      maxY = 1350;
      break;
    case "landscape":
      x = 1.91;
      y = 1.0;
      maxX = 1080;
      maxY = 566;
      break;
    default:
      x = 1.0;
      y = 1.0;
      maxX = 1080;
      maxY = 1080;
      break;
  }

  return await ImageCropper.cropImage(
    sourcePath: img.path,
    ratioX: x,
    ratioY: y,
    toolbarTitle: "Gramshoot",
    maxWidth: maxX,
    maxHeight: maxY,
  );
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  return img.encodePng(image);
}

String randomString(int strlen, String ext) {
  var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result + "." + ext;
}
