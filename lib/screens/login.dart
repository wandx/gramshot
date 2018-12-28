import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/models/credential.dart';

class Login extends StatefulWidget {
  final AppModel model;

  Login({@required this.model});

  @override
  LoginState createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  String username, password;
  Credential _credential;
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(left: 50.0, right: 5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 200.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Selamat datang,",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "masuk untuk melanjutkan",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  )
                ],
              ),
              SizedBox(height: 50.0),
              Container(
                child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                            gapPadding: 5.0,
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Username diperlukan";
                          }
                        },
                        onSaved: (value) {
                          setState(() => username = value);
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                            gapPadding: 5.0,
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Password diperlukan";
                          }
                        },
                        onSaved: (value) {
                          setState(() => password = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 55.0,
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.only(right: 100.0),
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.arrow_forward,
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    _formKey.currentState.save();
                    setState(
                      () => _credential = new Credential(
                            username: this.username,
                            password: this.password,
                          ),
                    );
                    await widget.model.login(_credential).then((_) {
                      if (widget.model.isAuth) {
                        Navigator.pushReplacementNamed(context, "root");
                      }
                    });
//                    Navigator.pushReplacementNamed(context, "home");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
