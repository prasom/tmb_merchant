import 'dart:async';
import 'validator.dart';
import 'package:rxdart/rxdart.dart';

class StateMgmtBloc extends Object with Validator {
  //Private fields
  final _usernameController = BehaviorSubject<
      String>(); //RxDart's implementation of StreamController. Broadcast stream by default
  final _passwordController = BehaviorSubject<String>();

  //Retreive data from the stream
  Stream<String> get usernameStream => _usernameController.stream
      .transform(performUserNameValidation); //Return the transformed stream
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(performPasswordValidation);

  //Merging email and password streams
  Stream<bool> get submitValid =>
      Observable.combineLatest2(usernameStream, passwordStream, (e, p) => true);

  //Add data to the stream
  Function(String) get updateUsername => _usernameController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;

  dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}
