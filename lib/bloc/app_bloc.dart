import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:link_share/bloc/actions/app_actions.dart';
import 'package:link_share/bloc/actions/auth_actions.dart';
import 'package:link_share/bloc/actions/link_actions.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/main.dart';
import 'package:link_share/screens/auth_flow/login.dart';
import 'package:link_share/screens/home_screen.dart';
import 'package:link_share/shared/custom_loader.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:link_share/utils/dependency_manager.dart';
import 'package:link_share/utils/feedback_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends Bloc<AppActions, AppState> {
  Account account = Account(AppWriteInit.appClient);

  AppBloc() : super(AppState()) {
    on<InitUser>((event, emit) async {

      try {
        User currentUser = await account.get();
        var response = await currentLinkService.getLinks(currentUser.$id);
        if(!response["status"]){
          showFeedbackToast(CustomLoader.dialogContext!, response['message']);
          emit(AppState(currentUser: currentUser));
        }
        emit(AppState(currentUser: currentUser,links: [...state.links,...response["result"]]));
      } catch (e) {
        Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool("isLoggedIn", true);
      }
      CustomLoader.dismiss();
    });
    on<RefreshLink>((event, emit) => emit(state.copyWith(updatedLinks: event.linkUpdate)));
    on<UpdateAppState>((event, emit) {
      emit(event.newState);
    });
    on<RegisterUser>((event, emit) async {
      emit(AppState(isLoading: true));

      var response =
          await currentUserService.registerUser(event.email, event.password);

      if (response['status']) {
        emit(AppState(isLoading: false, currentUser: response['result']));
        await Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }

      emit(AppState(
        isLoading: false,
      ));
      CustomLoader.dismiss();
      showFeedbackToast(CustomLoader.dialogContext!, response['message']);
    });
    on<LoginUser>((event, emit) async {
      emit(AppState(isLoading: true));
      var response =
          await currentUserService.loginUser(event.email, event.password);

      if (response["status"]) {
        emit(AppState(
          currentUser: response["result"],
        ));
        await Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }

      showFeedbackToast(CustomLoader.dialogContext!, response['message']);
      emit(AppState());
      CustomLoader.dismiss();
    });
    on<SyncLinks>((event, emit) async =>await currentLinkService.syncData(state.links, state.currentUser!.$id));
  }
}
