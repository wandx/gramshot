import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';

class Sidebar extends StatelessWidget {
  final AppModel model;

  Sidebar({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          ListTile(
            title: Text("Daftar Akun"),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.pushNamed(context, "accountList");
            },
          ),
          ListTile(
            title: Text("Jadwal Post"),
            leading: Icon(Icons.calendar_today),
            onTap: () {
              Navigator.pushNamed(context, "scheduleList");
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await model.logout().then((_) {
                Navigator.pushReplacementNamed(context, "root");
              });
            },
          )
        ],
      ),
    );
  }
}
