import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tmb_merchant/models/login_model.dart';

bool _isValidPassword(String password) {
  return password.length >= 4;
}

bool _isValidEmail(String email) {
  
  return email.length >= 4;
}

class LoginBloc {
  
  final _emailController = BehaviorSubject<String>(seedValue: '');
  final _passwordController = BehaviorSubject<String>(seedValue: '');
  final _loadingController = BehaviorSubject<bool>(seedValue: false);
  final _loginController = StreamController<Null>();

  final _emailTransformer = new StreamTransformer<String, String>.fromHandlers(
    handleData: (email, eventSink) {
      if (email != '') {
        eventSink.add(email);
      } else {
        eventSink.addError('Please enter user name!');
      }
    },
  );

  final _passwordTransformer =
      new StreamTransformer<String, String>.fromHandlers(
    handleData: (password, eventSink) {
      if (_isValidPassword(password)) {
        eventSink.add(password);
      } else {
        eventSink.addError('Please enter password!');
      }
    },
  );

  // sinks
  void Function(String) get emailChanged => _emailController.sink.add;

  void Function(String) get passwordChanged => _passwordController.sink.add;

  void Function() get submitLogin => () => _loginController.add(null);

  // streams
  Stream<String> get emailStream =>
      _emailController.stream.transform(_emailTransformer).distinct();

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(_passwordTransformer).distinct();

  Stream<bool> get isLoading => _loadingController.stream.distinct();

  Stream<Response> results;

  Stream<bool> validSubmit;

  final Api api;

  LoginBloc(this.api) : assert(api != null) {
    final credentialStream = Observable.combineLatest2(
      emailStream,
      passwordStream,
      (email, password) => Credential(email: email, password: password),
    );
    results = Observable(_loginController.stream)
        .withLatestFrom<Credential, Credential>(credentialStream, (_, e) => e)
        .flatMap(
          (credential) => Observable
              .fromFuture(api.login(credential))
              .doOnListen(() => _loadingController.add(true))
              .doOnEach((_) => _loadingController.add(false)),
        );
    validSubmit = Observable
        .combineLatest3(
          _emailController.map(_isValidEmail),
          _passwordController.map(_isValidPassword),
          _loadingController,
          (isValidEmail, isValidPassword, isLoading) =>
              isValidEmail && isValidPassword && !isLoading,
        )
        .distinct();
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _loginController.close();
    _loadingController.close();
  }
}
