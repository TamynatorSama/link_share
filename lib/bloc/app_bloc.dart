import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:link_share/bloc/actions/app_actions.dart';
import 'package:link_share/bloc/actions/auth_actions.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/main.dart';
import 'package:link_share/screens/auth_flow/login.dart';
import 'package:link_share/screens/home_screen.dart';
import 'package:link_share/shared/custom_loader.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:link_share/utils/feedback_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends Bloc<AppActions, AppState> {
  AppBloc() : super(AppState()) {
    on<InitUser>((event, emit) async {
      Account account = Account(AppWriteInit.appClient);

      try {
        User currentUser = await account.get();
        emit(AppState(currentUser: currentUser));
      } catch (e) {
        Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool("isLoggedIn", true);
      }
    });
    on<UpdateAppState>((event, emit) {
      emit(event.newState);
    });
    on<RegisterUser>((event, emit) async {
      emit(AppState(isLoading: true));
      Account createAccount = Account(AppWriteInit.appClient);

      try {
        User newUser = await createAccount.create(
            userId: ID.unique(), email: event.email, password: event.password);
        emit(AppState(isLoading: false, currentUser: newUser));
        await Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } catch (e) {
        if (e is AppwriteException) {
          showFeedbackToast(CustomLoader.dialogContext!, e.message ?? "");
        }
        showFeedbackToast(
            CustomLoader.dialogContext!, "unable to process your request");
        emit(AppState(isLoading: false));
      }
      CustomLoader.dismiss();
    });
    on<LoginUser>((event, emit) async {
      emit(AppState(isLoading: true));
      Account account = Account(AppWriteInit.appClient);
      try {
        await account.createEmailSession(
            email: event.email, password: event.password);

        User loggedInUser = await account.get();

        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.setBool("isLoggedIn", true);

        emit(AppState(
          currentUser: loggedInUser,
        ));
        await Navigator.pushAndRemoveUntil(
            MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } catch (e) {
        if (e is AppwriteException) {
          showFeedbackToast(CustomLoader.dialogContext!, e.message ?? "");
        }
        showFeedbackToast(
            CustomLoader.dialogContext!, "unable to process your request");
        emit(AppState());
      }
      CustomLoader.dismiss();
    });
  }
}
