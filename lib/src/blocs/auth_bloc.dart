import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tmb_merchant/src/models/login_model.dart';

class AuthBloc {
  final _loginController = StreamController<Null>();

  // sinks
  void Function() get submitLogin => () => _loginController.add(null);

  Stream<Response> results;

  // final Api api;
  // AuthBloc(this.api) {
    
  // }
}
