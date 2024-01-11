import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/bloc/actions/auth_actions.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/custom_input.dart';
import 'package:link_share/shared/custom_loader.dart';
import 'package:link_share/shared/shared_theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController(
        text: kDebugMode ? "kolawoletamilore1@gmail.com" : "");
    passwordController =
        TextEditingController(text: kDebugMode ? "fooBarBaz" : "");

        confirmPasswordController =
        TextEditingController(text: kDebugMode ? "fooBarBaz" : "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20, bottom: 64),
                  child:
                      SvgPicture.asset('assets/images/logo-devlinks-large.svg'),
                ),
                Text("Create account", style: AppTheme.headerText),
                const SizedBox(
                  height: 10,
                ),
                Text("Let’s get you started sharing your links!",
                    style: AppTheme.bodyText.copyWith(
                        fontSize: 18, color: const Color(0xff737373))),
                const SizedBox(
                  height: 40,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputField(
                          controller: emailController,
                          label: "Email Address",
                          hint: "e.g. alex@email.com",
                          svgPrefixIcon: "assets/images/icon-email.svg",
                          validator: (val) {
                            RegExp reg = RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                            if (!reg.hasMatch(val?.trim() ?? "")) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomInputField(
                          controller: passwordController,
                          label: "Create password",
                          hint: "At least .8 characters",
                          isPassword: true,
                          svgPrefixIcon: "assets/images/icon-password.svg",
                          // validator: (val) {
                          //   RegExp uppercaseReg = RegExp(r'(?=.*?[A-Z])');
                          //   RegExp specialCharReg = RegExp(r'(?=.*?[#?!@$%^&*-])');
                          //   if (!uppercaseReg.hasMatch(val ?? "")) {
                          //     return "Must contain an uppercase character";
                          //   }
                          //   if (!specialCharReg.hasMatch(val ?? "")) {
                          //     return "Must contain special character";
                          //   }
                          //   if (!specialCharReg.hasMatch(val ?? "")) {
                          //     return "Must contain special character";
                          //   }
                          // },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomInputField(
                          controller: confirmPasswordController,
                          label: "Confirm password",
                          hint: "At least .8 characters",
                          isPassword: true,
                          svgPrefixIcon: "assets/images/icon-password.svg",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Can't be empty";
                            }
                            if (val != passwordController.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          text: "Create new account",
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? true) {
                              FocusScope.of(context).unfocus();
                              CustomLoader.showLoader(context);
                              context.read<AppBloc>().add(RegisterUser(
                                  email: emailController.text.trim(),
                                  password: passwordController.text));
                            }
                          },
                        )
                      ],
                    )),
                const SizedBox(
                  height: 28,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: AppTheme.bodyText
                                .copyWith(color: const Color(0xff737373)),
                            children: [
                              const TextSpan(
                                  text: "Already have an account?\n"),
                              TextSpan(
                                  text: "Login",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppTheme.primaryColor)),
                            ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
