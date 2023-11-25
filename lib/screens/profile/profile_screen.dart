import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/repository/user_repository/user_service_interface.dart';
import 'package:link_share/screens/profile/widget/profile_info.dart';
import 'package:link_share/screens/profile/widget/upload_widget.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/shared_theme.dart';
import 'package:link_share/utils/dependency_manager.dart';
import 'package:link_share/utils/keyboard_checker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  bool activateButton = false;

  @override
  void initState() {
    User? currentUser = context.read<AppBloc>().state.currentUser;
    emailController = TextEditingController(text: currentUser?.email ?? "");
    firstNameController =
        TextEditingController(text: (currentUser?.name ?? "").split(" ").first)
          ..addListener(checkEditState);
    lastNameController = TextEditingController(
        text: (currentUser?.name ?? "").split(" ").length > 1
            ? (currentUser?.name ?? "").split(" ").last
            : "")
      ..addListener(checkEditState);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.removeListener(checkEditState);
    lastNameController.removeListener(checkEditState);
    super.dispose();
  }

  checkEditState() {
    bool newBtnState = activateButton;
    User? currentUser = context.read<AppBloc>().state.currentUser;

    if (firstNameController.text.trim() !=
            (currentUser!.name.isEmpty
                ? ""
                : currentUser.name.split(" ").first) ||
        lastNameController.text.trim() !=
            (currentUser.name.isEmpty
                ? ""
                : currentUser.name.split(" ").length > 1
                    ? currentUser.name.split(" ").last
                    : "")) {
      activateButton = true;
    }
    activateButton = false;
    if (newBtnState != activateButton) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Profile Details",
                          style: AppTheme.headerText,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add your details to create a personal touch to your profile.",
                          style: AppTheme.bodyText.copyWith(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const UploadImageWidget(),
                                const SizedBox(
                                  height: 30,
                                ),
                                ProfileInfo(
                                  firstNameController: firstNameController,
                                  lastNameController: lastNameController,
                                  emailController: emailController,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        )),
                        ListenableBuilder(
                            listenable: keyboardState,
                            builder: (context, child) {
                              return Offstage(
                                offstage: keyboardState.keyboardIsOpened,
                                child: Column(
                                  children: [
                                    const Divider(
                                      thickness: 1.3,
                                      // color: Color(0xFFFAFAFA),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: CustomButton(
                                        text: "Save",
                                        onTap: !activateButton
                                            ? null
                                            : () async {
                                                var response = await currentUserService.updateProfile(
                                                    UpdateType.name,
                                                    firstName: firstNameController.text.trim() !=
                                                            (state.currentUser!
                                                                    .name.isEmpty
                                                                ? ""
                                                                : state
                                                                    .currentUser!
                                                                    .name
                                                                    .split(" ")
                                                                    .first)
                                                        ? firstNameController
                                                            .text
                                                        : null,
                                                    lastName: lastNameController
                                                                .text
                                                                .trim() !=
                                                            (state.currentUser!
                                                                    .name.isEmpty
                                                                ? ""
                                                                : state.currentUser!.name.split(" ").length >
                                                                        1
                                                                    ? state
                                                                        .currentUser!
                                                                        .name
                                                                        .split(" ")
                                                                        .last
                                                                    : "")
                                                        ? lastNameController.text
                                                        : null);
                                              },
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                                  .padding
                                                  .bottom <
                                              10
                                          ? 10
                                          : MediaQuery.of(context)
                                                  .padding
                                                  .bottom +
                                              10,
                                    ),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
