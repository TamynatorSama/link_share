import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/models/link_model.dart';

@immutable
abstract class AppActions {
  const AppActions();
}

class InitUser extends AppActions {
  final BuildContext context;
  const InitUser(this.context);
}

class RefreshLink extends AppActions {
  final List<LinkModel> linkUpdate;
  const RefreshLink(this.linkUpdate);
}

class UpdateAppState extends AppActions {
  final AppState newState;

  const UpdateAppState(this.newState);
}
