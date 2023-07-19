import 'package:flutter/material.dart';
import 'package:link_share/screens/profile/widget/profile_info.dart';
import 'package:link_share/screens/profile/widget/upload_widget.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/shared_theme.dart';
import 'package:link_share/utils/keyboard_checker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: const SingleChildScrollView(
                          child: Column(
                            children: [
                              UploadImageWidget(),
                              SizedBox(
                                height: 30,
                              ),
                              ProfileInfo(),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      )),
                      ListenableBuilder(
                        listenable: keyboardState,
                        builder: (context,child) {
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: CustomButton(text: "Save"),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).padding.bottom < 10
                                      ? 10
                                      : MediaQuery.of(context).padding.bottom + 10,
                                ),
                              ],
                            ),
                          );
                        }
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
