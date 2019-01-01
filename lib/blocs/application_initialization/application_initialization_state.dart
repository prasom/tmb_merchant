import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:meta/meta.dart';

class ApplicationInitializationState extends BlocState {
  ApplicationInitializationState({
    @required this.isInitialized,
    this.isInitializing: false,
    this.isIgnoreDecisionPage: false,
    this.progress: 0,
  });

  final bool isInitialized;
  final bool isInitializing;
  final bool isIgnoreDecisionPage;
  final int progress;

  factory ApplicationInitializationState.notInitialized() {
    return ApplicationInitializationState(
      isInitialized: false,
      isIgnoreDecisionPage: false
    );
  }

  factory ApplicationInitializationState.progressing(int progress,bool isIgnoreDecisionPage) {
    return ApplicationInitializationState(
      isInitialized: progress == 100,
      isInitializing: true,
      progress: progress,
      isIgnoreDecisionPage: isIgnoreDecisionPage ?? false
    );
  }

  factory ApplicationInitializationState.initialized() {
    return ApplicationInitializationState(
      isInitialized: true,
      progress: 100,
      isIgnoreDecisionPage: false
    );
  }

  factory ApplicationInitializationState.initializedIgnoreDecistionpage() {
    return ApplicationInitializationState(
      isInitialized: true,
      progress: 100,
      isIgnoreDecisionPage: true
    );
  }
}