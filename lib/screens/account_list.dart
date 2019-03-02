import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gramshot/app_model.dart';
import 'package:gramshot/repos/account_repo.dart' as accountRepo;
import 'package:gramshot/screens/account_edit.dart';
import 'package:gramshot/utils/helpers.dart' as helpers;

class AccountList extends StatefulWidget {
  final AppModel model;

  AccountList({@required this.model});

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final _refreshIndicatorState = new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;

  @override
  void initState() {
    widget.model.getAccounts().then((_) async {
      widget.model.getDefaultAccount();
    }).then((_) {
      setState(() => _isLoading = false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Akun"),
      ),
      floatingActionButton: Visibility(
        visible: widget.model.accounts.length <=
            widget.model.user.package.accountCount,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, "accountAdd").then((res) async {
              if (res != null && res) {
                _refreshIndicatorState.currentState.show();
              }
            });
          },
          child: Icon(Icons.add),
        ),
      ),
      body: _isLoading
          ? helpers.loader()
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
//                  _defaultAccountCard(),
                  Expanded(
                    child: RefreshIndicator(
                      key: _refreshIndicatorState,
                      onRefresh: () async {
                        await widget.model.getAccounts();
                      },
                      child: ListView.builder(
                        itemCount: widget.model.accounts.length,
                        itemBuilder: (context, idx) => ListTile(
                              title: Text(
                                widget.model.accounts[idx]?.username,
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => <PopupMenuEntry>[
//                                      PopupMenuItem(
//                                        child: GestureDetector(
//                                          child: Text("Set Default"),
//                                          onTap: () async {
//                                            await widget.model
//                                                .setDefaultAccount(
//                                              widget.model.accounts[idx].id,
//                                            );
//                                            Navigator.pop(context);
//                                          },
//                                        ),
//                                      ),
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          child: Text("Edit Akun"),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    new AccountEdit(
                                                      account: widget
                                                          .model.accounts[idx],
                                                    ),
                                              ),
                                            ).then((res) {
                                              if (res != null && res) {
                                                _refreshIndicatorState
                                                    .currentState
                                                    .show();
                                              }
                                            }).then((_) {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          child: Text("Hapus Akun"),
                                          onTap: () async {
                                            await _confirmDelete(
                                              context,
                                              widget.model.accounts[idx].id,
                                              widget
                                                  .model.accounts[idx].username,
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                              ),
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  _defaultAccountCard() {
    return Card(
      elevation: 0.0,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "default : ${widget.model.defaultAccount?.username ?? '-'}",
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future _confirmDelete(BuildContext context, String id, String name) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus akun ?"),
          content: Text("Akun $name akan dihapus beserta data yang terkait."),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            FlatButton(
              onPressed: () async {
                await accountRepo.deleteAccount(id).then((res) async {
                  await widget.model.getAccounts();
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Hapus",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }
}
