import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/models/link_model.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/link_to_color.dart';
import 'package:link_share/shared/link_to_svg.dart';
import 'package:link_share/shared/shared_theme.dart';
import 'package:link_share/utils/feedback_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Preview extends StatelessWidget {
  const Preview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                  child: CustomButton(
                text: "Back to Editor",
                onTap: () {
                  Navigator.pop(context);
                },
                inverted: true,
              )),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                  child: CustomButton(
                text: "Share Link",
                onTap: () {},
              )),
            ],
          ),
          // title:
        ),
        body: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) => SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      state.image == null
                          ? const CircleAvatar(
                              radius: 70,
                              backgroundColor: Color(0xffEEEEEE),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                                CircleAvatar(
                                  radius: 65,
                                  backgroundImage: state.image == null
                                      ? null
                                      : CachedMemoryImageProvider(
                                          state.currentUser!.prefs
                                              .data["profile_id"],
                                          bytes: state.image),
                                )
                              ],
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      state.currentUser?.prefs.data["first_name"] == null &&
                              state.currentUser?.prefs.data["last_name"] == null
                          ? Container(
                              width: 200,
                              height: 20,
                              decoration: const ShapeDecoration(
                                  color: Color(0xffEEEEEE),
                                  shape: StadiumBorder()),
                            )
                          : Text(
                              "${state.currentUser?.prefs.data["first_name"]} ${state.currentUser?.prefs.data["last_name"]}",
                              style: AppTheme.headerText.copyWith(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                      state.currentUser?.email == null
                          ? Container(
                              width: 120,
                              height: 15,
                              decoration: const ShapeDecoration(
                                  color: Color(0xffEEEEEE),
                                  shape: StadiumBorder()),
                            )
                          : Text(
                              "${state.currentUser?.email}",
                              style: AppTheme.bodyText,
                            ),
                      const Row(),
                      const SizedBox(
                        height: 35,
                      ),
                      Wrap(
                        runSpacing: 20,
                        children: List.generate(
                            state.links.length,
                            (index) =>
                                _buildLinkWidget(state.links[index], context)),
                      )
                    ],
                  ),
                ))));
  }

  Widget _buildLinkWidget(LinkModel link, BuildContext context) => InkWell(
      onTap: () async {
        final Uri _url = Uri.parse(link.linkUrl);
        await launchUrl(_url).then((value) {
          if (!value) {
          showFeedbackToast(context, "Unable to launch url");
        }
        });
      },
      child: Container(
          width: double.maxFinite,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: linksColor[link.linkName] ?? Colors.red,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  linksWithColor[link.linkName]!,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    link.linkName,
                    style: AppTheme.buttonText,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          )));
}
