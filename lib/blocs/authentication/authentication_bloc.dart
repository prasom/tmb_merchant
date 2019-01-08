import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmb_merchant/apis/login_api.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:tmb_merchant/bloc_helpers/prefs_singleton.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/models/preference_names.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/models/user_model.dart';

class AuthenticationBloc
    extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc()
      : super(
          initialState: AuthenticationState.notAuthenticated(),
        ) {
    loadActiveFaceIdState();
    _loadState();
  }

  LoginApi api = new LoginApi();

  final SharedPreferences prefs = PrefsSingleton.prefs;
  // List of all items, part of the shopping basket
  List<String> _pinStorage = List<String>();

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      // Inform that we are proceeding with the authentication
      yield AuthenticationState.authenticating();
      try {
        // Simulate a call to the authentication server
        final User hasToken = await api.login(event.username, event.passowrd);

        // Inform that we have successfuly authenticated, or not
        if (hasToken != null) {
          yield AuthenticationState.authenticated(hasToken.compcode);
          await saveCurrentUser(hasToken);
        } else {
          yield AuthenticationState.failure();
        }
      } catch (e) {
        yield AuthenticationState.failure();
      }
    }

    if (event is AuthenticationEventPinLogin) {
      // Inform that we are proceeding with the authentication
      yield AuthenticationState.authenticating();

      // Simulate a call to the authentication server
      var currentPin = _pinStorage.join('');
      final localStoragePin = await _getLocalStoragePin();
      if (event.faceId) {
        currentPin = localStoragePin;
      }
      // Inform that we have successfuly authenticated, or not
      if (localStoragePin == currentPin) {
        yield AuthenticationState.pinAuthenticated(_pinStorage.join(''));
      } else {
        await resetPin();
        yield AuthenticationState.failure();
      }
    }

    if (event is AuthenticationEventSetPin) {
      // Inform that we are proceeding with the authentication
      yield AuthenticationState.authenticating();
      try {
        // Simulate a call to the authentication server
        final hasToken = await _hasToken();

        // Inform that we have successfuly authenticated, or not
        if (hasToken) {
          yield AuthenticationState.pinAuthenticated(_pinStorage.join(''));
          await savePin(_pinStorage.join(''));
        } else {
          yield AuthenticationState.failure();
        }
      } catch (e) {
        yield AuthenticationState.failure();
      }
    }

    if (event is AuthenticationEventLogout) {
      yield AuthenticationState.notAuthenticated();
      await deleteCurrentState();
    }
  }

  BehaviorSubject<int> _pinSizeController = BehaviorSubject<int>(seedValue: 0);
  Stream<int> get pintSize => _pinSizeController;

  // current user
  // BehaviorSubject<String> _currentUserController =
  //     BehaviorSubject<String>(seedValue: null);
  // Stream<String> get currentUserController => _currentUserController;
// Reactive variables
  final _currentUserController = BehaviorSubject<User>();
  Observable<User> get streamCurrentUser => _currentUserController.stream;
  Function(User) get _sinkCurrentUser => _currentUserController.sink.add;

  final _storagePinController = BehaviorSubject<String>();
  Observable<String> get _streamStoragePinController =>
      _storagePinController.stream;
  Function(String) get _sinkStoragePinController =>
      _storagePinController.sink.add;

  // Stream to list the items part of the shopping basket
  BehaviorSubject<List<String>> _pinController =
      BehaviorSubject<List<String>>(seedValue: <String>[]);
  Stream<List<String>> get pinStorage => _pinController;

  Future<bool> _hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<User> _loginToken(username, password) async {
    /// read from keystore/keychain
    final user = await api.login(username, password);
    return user;
  }

  // Persistence Functions
  Future saveCurrentUser(User token) async {
    String userJson = jsonEncode(token);
    await prefs.setString(PreferenceNames.currentUser, userJson);
    _sinkCurrentUser(token);
  }

  // Persistence Functions
  Future savePin(String pin) async {
    await prefs.setString(PreferenceNames.loginPin, pin);
  }

  // Persistence Functions
  Future resetPin() async {
    _pinSizeController.add(0);
    _pinStorage.clear();
  }

  // Persistence Functions
  Future deleteCurrentState() async {
    _pinSizeController.add(0);
    _pinStorage.clear();
    await prefs.setString(PreferenceNames.loginPin, null);
    await prefs.setString(PreferenceNames.currentUser, null);
  }

  Future<User> _getCurrentUser() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return _currentUserController.value;
  }

  Future<String> _getStoragePin() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return _storagePinController.value;
  }

  Future<String> _getLocalStoragePin() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return prefs.getString(PreferenceNames.loginPin);
  }

  void enterPin(String item) {
    _pinStorage.add(item);
    _postActionOnPin();
  }

  void removePin() {
    _pinStorage.removeLast();
    _postActionOnPin();
  }

  void _postActionOnPin() {
    _pinSizeController.add(_pinStorage.length);
  }

  _loadState() {
    final _currentUser = prefs.getString(PreferenceNames.currentUser) ?? null;
    if (_currentUser != null) {
      Map<String, dynamic> user = jsonDecode(_currentUser);
      final finalUser = User.fromJson(user);
      _sinkCurrentUser(finalUser);
    }
  }

  // activate face id
  final _activateFaceIdController = BehaviorSubject<bool>();

  Observable<bool> get activateFaceId => _activateFaceIdController.stream;

  Function(bool) get _changeActivateFaceId =>
      _activateFaceIdController.sink.add;

  Future changeActivateFaceId(bool request) async {
    _changeActivateFaceId(request);
    saveActivateFaceId();
  }

  Future saveActivateFaceId() async {
    await prefs.setBool(
        PreferenceNames.faceId, _activateFaceIdController.value);
  }

  void toggleActiveFaceId(bool request) {
    changeActivateFaceId(request);
  }

  void loadActiveFaceIdState() {
    _changeActivateFaceId(prefs.getBool(PreferenceNames.faceId) ?? false);
  }
}
