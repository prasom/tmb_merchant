import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tmb_merchant/models/login_model.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/utils/network_util.dart';

class LoginApi{
   NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://ggdemo-212710.appspot.com/api";
  static final LOGIN_URL = BASE_URL + "/login";
  Future<User> login(String username, String password) {
    try {
       return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if(res["message"] != null) throw new Exception(res["message"]);
      return new User.map(res["result"]);
    });
    } catch (e) {
      throw new Exception('login fail');
    }
   
  }
}