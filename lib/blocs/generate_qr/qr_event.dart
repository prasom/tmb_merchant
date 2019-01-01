import 'package:flutter/material.dart';
import 'package:tmb_merchant/models/qr_model.dart';

abstract class QrEvent {}

class GenerateQr extends QrEvent {
  final QrRequest request;

  GenerateQr({@required this.request});
  // final String ref1;
  // final String ref2;
  // final String price;

  // GenerateQr({@required this.ref1, @required this.ref2, @required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateQr &&
          runtimeType == other.runtimeType &&
          request == other.request;

  @override
  int get hashCode => request.hashCode;
}

class GenerateQrSuccess extends QrEvent {
  final String qrUrl;
  final String price;

  GenerateQrSuccess({@required this.qrUrl, @required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateQrSuccess &&
          runtimeType == other.runtimeType &&
          qrUrl == other.qrUrl &&
          price == other.price;

  @override
  int get hashCode => qrUrl.hashCode ^ price.hashCode;
}

class EditQr extends QrEvent {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditQr && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'EditQr';
}
