import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/bloc/actions/auth_actions.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/screens/auth_flow/signup.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/custom_input.dart';
import 'package:link_share/shared/custom_loader.dart';
import 'package:link_share/shared/shared_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController(
        text: kDebugMode ? "kolawoletamilore1@gmail.com" : "");
    passwordController =
        TextEditingController(text: kDebugMode ? "fooBarBaz" : "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20, bottom: 64),
              child: SvgPicture.asset('assets/images/logo-devlinks-large.svg'),
            ),
            Text("Login", style: AppTheme.headerText),
            const SizedBox(
              height: 10,
            ),
            Text("Add your details below to get back into the app",
                style: AppTheme.bodyText
                    .copyWith(fontSize: 18, color: const Color(0xff737373))),
            const SizedBox(
              height: 40,
            ),
            Form(
                child: Column(
              children: [
                CustomInputField(
                  controller: emailController,
                  label: "Email Address",
                  hint: "e.g. alex@email.com",
                  svgPrefixIcon: "assets/images/icon-email.svg",
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomInputField(
                  controller: passwordController,
                  label: "Password",
                  hint: "Enter your password",
                  isPassword: true,
                  validator: (val) {
                    if (val.toString().isEmpty) {
                      return "Can't be empty";
                    }
                    return null;
                  },
                  svgPrefixIcon: "assets/images/icon-password.svg",
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    text: "Login",
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? true) {
                        FocusScope.of(context).unfocus();
                        CustomLoader.showLoader(context);
                        context.read<AppBloc>().add(LoginUser(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                    })
              ],
            )),
            const SizedBox(
              height: 28,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUp())),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: AppTheme.bodyText
                            .copyWith(color: const Color(0xff737373)),
                        children: [
                          const TextSpan(text: "Don’t have an account?\n"),
                          TextSpan(
                              text: "Create account",
                              style: AppTheme.bodyText
                                  .copyWith(color: AppTheme.primaryColor)),
                        ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
