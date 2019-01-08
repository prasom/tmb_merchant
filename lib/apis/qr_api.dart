import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tmb_merchant/models/login_model.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/utils/network_util.dart';

class QrApi {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://ggdemo-212710.appspot.com/api";
  static final GENQR_URL = BASE_URL + "/qrGenerate";
  Future<String> generateQr(String compcode,String ref1, String ref2,String price) {
    try {
      return _netUtil.post(GENQR_URL, body: {
        "compcode": compcode,
        "ref1": ref1,
        "ref2": ref2,
        "price": price,
      }).then((dynamic res) {
        print(res.toString());
        if (res["message"] != null) throw new Exception(res["message"]);
        return res["result"]['qrUrl'];
      });
    } catch (e) {
      throw new Exception('login fail');
    }
  }
}
