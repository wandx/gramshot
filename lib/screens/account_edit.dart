import 'package:flutter/material.dart';
import 'package:gramshot/models/account.dart';
import 'package:gramshot/repos/account_repo.dart' as accountRepo;

class AccountEdit extends StatefulWidget {
  final Account account;

  AccountEdit({@required this.account});

  @override
  AccountEditState createState() {
    return new AccountEditState();
  }
}

class AccountEditState extends State<AccountEdit> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username;
  String _password;
  String _description;

  @override
  void initState() {
    _username = widget.account.username;
    _description = widget.account.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit ${widget.account.username}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _formKey.currentState.save();
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> body = {
              "id": widget.account.id,
              "username": _username,
              "password": _password ?? null,
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
                initialValue: _username,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Instagram password"),
                onSaved: (v) {
                  setState(() => _password = v);
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Deskripsi"),
                onSaved: (v) {
                  setState(() => _description = v);
                },
                initialValue: _description,
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
