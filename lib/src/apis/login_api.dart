import 'package:tmb_merchant/src/models/login_model.dart';
import 'dart:math';

class Api {
  static Api _instance;

  factory Api() => _instance ??= Api._();

  Api._();

  //simulate login
  Future<Response> login(Credential credential) {
    final response = Random().nextBool()
        ? SuccessResponse(
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibm'
                'FtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
          )
        : ErrorResponse("An error occurred");
    return Future.delayed(
      Duration(seconds: 3),
      () => response,
    );
  }
}