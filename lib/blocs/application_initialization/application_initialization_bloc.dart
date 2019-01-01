import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:tmb_merchant/bloc_helpers/prefs_singleton.dart';
import 'package:tmb_merchant/blocs/application_initialization/application_initialization_event.dart';
import 'package:tmb_merchant/blocs/application_initialization/application_initialization_state.dart';
import 'package:tmb_merchant/models/preference_names.dart';

class ApplicationInitializationBloc extends BlocEventStateBase<
    ApplicationInitializationEvent, ApplicationInitializationState> {
  ApplicationInitializationBloc()
      : super(
          initialState: ApplicationInitializationState.notInitialized(),
        );

  final SharedPreferences prefs = PrefsSingleton.prefs;

  @override
  Stream<ApplicationInitializationState> eventHandler(
      ApplicationInitializationEvent event,
      ApplicationInitializationState currentState) async* {
    if (!currentState.isInitialized) {
      yield ApplicationInitializationState.notInitialized();
    }

    if (event.type == ApplicationInitializationEventType.start) {
      final _user = await _getCurrentUser();
      final _pin = await _getStoragePin();
      final isIgnoreDecisionPage = _user.isNotEmpty && _pin.isNotEmpty;
      for (int progress = 0; progress < 101; progress += 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        yield ApplicationInitializationState.progressing(progress,isIgnoreDecisionPage);
      }
    }

    if (event.type == ApplicationInitializationEventType.initialized) {
      final _user = await _getCurrentUser();
      final _pin = await _getStoragePin();
      if (_user.isNotEmpty && _pin.isNotEmpty) {
        yield ApplicationInitializationState.initializedIgnoreDecistionpage();
      } else {
        yield ApplicationInitializationState.initialized();
      }
    }
  }

  Future<String> _getCurrentUser() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return prefs.getString(PreferenceNames.currentUser) ?? '';
  }

  Future<String> _getStoragePin() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return prefs.getString(PreferenceNames.loginPin) ?? '';
  }
}
