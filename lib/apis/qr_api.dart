import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tmb_merchant/models/login_model.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/utils/network_util.dart';

import 'package:http/http.dart' as http;

class QrApi {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://promptpay.io";
  Future<String> generateQr(
      String compcode, String ref1, String ref2, String price) {
    final qrUrl = '$BASE_URL/$ref1/$price.png';
    return http.get(qrUrl).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      return qrUrl;
    });
    // try {
    //   final qrUrl = '$BASE_URL/$ref1/$price.png';
    //   return _netUtil.get(qrUrl).then((dynamic res) {
    //     if (res["errorMessage"] != null)
    //       throw new Exception(res["errorMessage"]);
    //     return qrUrl.toString();
    //   });
    // } catch (e) {
    //   throw new Exception('login fail');
    // }
  }
}
