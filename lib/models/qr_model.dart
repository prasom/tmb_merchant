import 'package:flutter/material.dart';

class QrRequest {
  final String compcode;
  final String ref1;
  final String ref2;
  final String price;
  final String qrUrl;

  QrRequest({
    @required this.compcode,
    @required this.ref1,
    @required this.ref2,
    @required this.price,
    this.qrUrl,
  });
}

class QrResponse {
  final String qrUrl;

  QrResponse({@required this.qrUrl});
}
