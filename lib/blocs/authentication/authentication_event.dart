import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String name;

  AuthenticationEvent({
    this.name: '',
  });
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({
    String name,
  }) : super(
          name: name,
        );
}

class AuthenticationEventPinLogin extends AuthenticationEvent {
  final bool faceId;

  AuthenticationEventPinLogin({this.faceId: false});
}

class AuthenticationEventSetPin extends AuthenticationEvent {}

class AuthenticationEventLogout extends AuthenticationEvent {}

class AuthenticationEventCheckStorageAuth extends AuthenticationEvent {}
