import 'package:flutter/foundation.dart' show immutable;
import 'package:link_share/bloc/appState/app_state.dart';

@immutable
abstract class AppActions {
  const AppActions();
}

class InitUser extends AppActions {}

class UpdateAppState extends AppActions {
  final AppState newState;

  const UpdateAppState(this.newState);
}
