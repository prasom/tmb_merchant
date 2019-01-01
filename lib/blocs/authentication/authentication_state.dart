import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:meta/meta.dart';

class AuthenticationState extends BlocState {
  AuthenticationState({
    @required this.isAuthenticated,
    @required this.isPinAuthenticated,
    this.isAuthenticating: false,
    this.hasPin: false,
    this.hasCurrentuser: false,
    this.hasFailed: false,
    this.storageChecked: false,
    this.name: '',
  });

  final bool isAuthenticated;
  final bool isPinAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;
  final bool hasPin;
  final bool hasCurrentuser;
  final bool storageChecked;

  final String name;

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      isAuthenticated: false,
      isPinAuthenticated: false,
      hasPin: false,
      hasCurrentuser: false,
      storageChecked: false,
    );
  }

  factory AuthenticationState.requirePinAuthenticated() {
    return AuthenticationState(
        isAuthenticated: false,
        isPinAuthenticated: false,
        hasPin: true,
        hasCurrentuser: true,
        storageChecked: true);
  }

  factory AuthenticationState.authenticated(String name) {
    return AuthenticationState(
      isAuthenticated: true,
      isPinAuthenticated: false,
      storageChecked: true,
      name: name,
    );
  }

  factory AuthenticationState.pinAuthenticated(String name) {
    return AuthenticationState(
      isAuthenticated: true,
      isPinAuthenticated: true,
      storageChecked: true,
    );
  }

  factory AuthenticationState.authenticating() {
    return AuthenticationState(
      isAuthenticated: false,
      isPinAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory AuthenticationState.failure() {
    return AuthenticationState(
      isAuthenticated: false,
      isPinAuthenticated: false,
      hasFailed: true,
    );
  }
}
