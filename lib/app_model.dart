import 'dart:async';

import 'package:gramshot/models/account.dart';
import 'package:gramshot/models/credential.dart';
import 'package:gramshot/models/media.dart';
import 'package:gramshot/models/schedule.dart';
import 'package:gramshot/models/user.dart';
import 'package:gramshot/repos/account_repo.dart' as accountRepo;
import 'package:gramshot/repos/auth_repo.dart' as authRepo;
import 'package:gramshot/repos/media_repo.dart' as mediaRepo;
import 'package:gramshot/repos/schedule_repo.dart' as scheduleRepo;
import 'package:gramshot/repos/user_repo.dart' as userRepo;
import 'package:gramshot/utils/helpers.dart' as helpers;
import 'package:scoped_model/scoped_model.dart';


class AppModel extends Model {
  User user;
  bool isLoading = true, isAuth = false;
  List<Media> media = [];
  List<Account> accounts = [];
  List<Schedule> schedules = [];
  Account defaultAccount;

  // check auth status
  Future<bool> checkAuth() async {
    return await helpers.checkAuth().then((Map<String, dynamic> res) async {
      this.isAuth = res["result"];
      this.user = res["user"] as User;
      await this.getMedia();
      await this.getAccounts();
//      this.getDefaultAccount();
      return res["result"] as bool;
    });
  }

  // get media
  Future<Null> getMedia() async {
    this.media.clear();
    await mediaRepo.getMedia().then((List<Media> m) {
      this.media.addAll(m);
      notifyListeners();
    });
  }

  // get accounts
  Future<Null> getAccounts() async {
    this.accounts.clear();
    await accountRepo.getAccounts().then((List<Account> a) {
      this.accounts.addAll(a);
      notifyListeners();
    });
  }

  // get default account
  getDefaultAccount() {
    try {
      Account d = this.accounts.firstWhere((Account a) => a.isDefault);
      if (d != null) {
        defaultAccount = d ?? null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // set default account
  setDefaultAccount(String id) async {
    Map<String, dynamic> body = {"id": id};

    await accountRepo.setDefaultAccount(body).then((res) async {
      if (res) {
        await this.getAccounts().then((_) {
          this.getDefaultAccount();
        });
      }
    }).then((_) {
      notifyListeners();
    });
  }

  // get schedules
  Future<Null> getSchedule() async {
    this.schedules.clear();
    await scheduleRepo.getSchedules().then((List<Schedule> s) {
      this.schedules.addAll(s);
      notifyListeners();
    });
  }

  // login
  Future<Null> login(Credential credential) async {
    await authRepo.login(credential).then((_) async {
      return await userRepo.me().then((User u) {
        this.user = u;
        return u != null;
      });
    }).then((bool isLoggedIn) async {
      this.isAuth = isLoggedIn;
      await this.getMedia();
    }).catchError((error) {
      print(error);
    });
  }

  // logout
  Future<Null> logout() async {
    await authRepo.logout().then((_) {
      this.isAuth = false;
    });
  }
}
