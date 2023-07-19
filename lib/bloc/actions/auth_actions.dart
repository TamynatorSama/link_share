import 'package:link_share/bloc/actions/app_actions.dart';

class RegisterUser implements AppActions {
  final String email;
  final String password;

  RegisterUser({required this.email,required this.password});
}

class LoginUser implements AppActions {
  final String email;
  final String password;

  LoginUser({required this.email,required this.password});
}