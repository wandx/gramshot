import 'package:flutter/material.dart';
import 'package:gramshot/repos/account_repo.dart' as accountRepo;

class AccountAdd extends StatefulWidget {
  @override
  AccountAddState createState() {
    return new AccountAddState();
  }
}

class AccountAddState extends State<AccountAdd> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username;
  String _password;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Tambah Akun"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _formKey.currentState.save();
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> body = {
              "username": _username,
              "password": _password,
              "description": _description ?? ""
            };

            await accountRepo.storeAccount(body).then((res) {
              if (res) {
                Navigator.pop(context, true);
              } else {
                _showSnackbar("Gagal menambahkan akun");
              }
            });
          }
        },
        child: Icon(Icons.save),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Instagram username"),
                validator: (v) {
                  if (v.isEmpty) {
                    return "username diperlukan";
                  }
                },
                onSaved: (v) {
                  setState(() => _username = v);
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Instagram password"),
                validator: (v) {
                  if (v.isEmpty) {
                    return "password diperlukan";
                  }
                },
                onSaved: (v) {
                  setState(() => _password = v);
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Deskripsi"),
                onSaved: (v) {
                  setState(() => _description = v);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showSnackbar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }
}
