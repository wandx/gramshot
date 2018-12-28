import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String imgPath;
  final String captions;

  DetailImage({@required this.imgPath, @required this.captions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.network(
                this.imgPath,
              ),
            ),
            Center(
              child: Text(this.captions),
            ),
          ],
        ),
      ),
    );
  }
}
