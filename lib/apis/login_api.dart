import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tmb_merchant/models/login_model.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/utils/network_util.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://ggdemo-212710.appspot.com/api";
  static final LOGIN_URL = BASE_URL + "/login";
  Future<User> login(String username, String password) async {
    final responseMock =
        "{\"result\":{\"compcode\":\"$username\",\"name\":\"$username\",\"logo\":\"https://promptpay.io/$username.png\"}}";

    final qrUrl = 'https://promptpay.io/$username.png';
    return http.get(qrUrl).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      var res = jsonDecode(responseMock);
      var user = User.map(res["result"]);
      return user;
    });
  }
}
