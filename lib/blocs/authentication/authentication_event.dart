import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String name;
  final String passowrd;

  AuthenticationEvent({
    this.name: '',
    this.passowrd: '',
  });
}

class AuthenticationEventLogin extends AuthenticationEvent {
  final String username ;
  final String passowrd ;

  AuthenticationEventLogin({@required this.username,@required this.passowrd});
}

class AuthenticationEventPinLogin extends AuthenticationEvent {
  final bool faceId;

  AuthenticationEventPinLogin({this.faceId: false});
}

class AuthenticationEventSetPin extends AuthenticationEvent {}

class AuthenticationEventLogout extends AuthenticationEvent {}

class AuthenticationEventCheckStorageAuth extends AuthenticationEvent {}
