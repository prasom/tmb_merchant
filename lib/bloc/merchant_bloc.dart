import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmb_merchant/src/models/preference_names.dart';
import 'package:tmb_merchant/src/providers/prefs_singleton.dart';

class MerchantBloc {
  DiceBloc() {
    loadState();
  }

// Regular variables
  final SharedPreferences prefs = PrefsSingleton.prefs;

  // Reactive variables
  final _merchant = BehaviorSubject<String>();

// Streams
  Observable<String> get merchant => _merchant.stream;

  // Sinks
  Function(String) get _changeMerchant => _merchant.sink.add;

  void loadState() {
    _changeMerchant(prefs.getString(PreferenceNames.merchant) ?? null);
  }

  // Persistence Functions
  Future saveState() async {
    await prefs.setString(PreferenceNames.merchant, _merchant.value);
  }

  Future dispose() async {
    // cleanup
    _merchant.close();
  }
}
