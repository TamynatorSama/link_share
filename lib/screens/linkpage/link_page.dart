import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_share/bloc/actions/app_actions.dart';
import 'package:link_share/bloc/appState/app_state.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/models/link_model.dart';
import 'package:link_share/screens/linkpage/widget/empty_place_holder.dart';
import 'package:link_share/screens/linkpage/widget/link_editior.dart';
import 'package:link_share/shared/custom_button.dart';
import 'package:link_share/shared/shared_theme.dart';
import 'package:link_share/utils/dependency_manager.dart';
import 'package:link_share/utils/keyboard_checker.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  late ScrollController newController;

  @override
  void initState() {
    newController = ScrollController();
    super.initState();
  }

  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  // Future refresh(){}


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{},
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: Column(
          children: [
            BlocConsumer<AppBloc, AppState>(
                listener: (context, listenerState) {},
                builder: (context, state) {
                  return Expanded(
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
                                "Customize your links",
                                style: AppTheme.headerText,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Add/edit/remove links below and then share all your profiles with the world!",
                                style: AppTheme.bodyText.copyWith(fontSize: 18),
                              ),
                              AnimatedBuilder(
                                animation: keyboardState,
                                builder: (context, child) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: ((MediaQuery.of(context).size.height *
                                              0.05) -
                                          (keyboardState.keyboardIsOpened
                                              ? 30
                                              : 0))
                                      .clamp(10, 40),
                                ),
                              ),
                              CustomButton(
                                  text: "+ Add new link",
                                  inverted: true,
                                  onTap: () {
                                    setState(() {
                                      LinkModel.linksSynced = false;
                                    });
      
                                    List<LinkModel> allLinks = state.links;
                                    LinkModel newLink =
                                        LinkModel(linkName: "", linkUrl: "");
      
                                    allLinks = [...allLinks, newLink];
                                    var newState =
                                        state.copyWith(updatedLinks: allLinks);
      
                                    context
                                        .read<AppBloc>()
                                        .add(UpdateAppState(newState));
                                    LinkModel.createdLinks.add(newLink.id);
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: state.links.isNotEmpty
                                      ? ReorderableListView.builder(
                                          scrollController: newController,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return LinkEditor(
                                              key:
                                                  ValueKey(state.links[index].id),
                                              remove: () {
                                                List<LinkModel> links =
                                                    state.links;
                                                validateDeleteLink(
                                                    links[index].id);
      
                                                links.removeAt(index);
                                                context.read<AppBloc>().add(
                                                    UpdateAppState(state.copyWith(
                                                        updatedLinks: links)));
                                              },
                                              update: validateUpdate,
                                              model: state.links[index],
                                              index: index + 1,
                                            );
                                          },
                                          itemCount: state.links.length,
                                          onReorder: (oldIndex, newIndex) {
                                            List<LinkModel> links = state.links;
                                            if (oldIndex < newIndex) {
                                              newIndex -= 1;
                                            }
                                            final LinkModel item =
                                                links.removeAt(oldIndex);
                                            links.insert(newIndex, item);
                                            context.read<AppBloc>().add(
                                                UpdateAppState(state.copyWith(
                                                    updatedLinks: links)));
                                          })
                                      : const SingleChildScrollView(
                                          child: Column(
                                            children: [EmptyPlaceHolder()],
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
                                              shouldShowLoader: true,
                                              onTap: LinkModel.linksSynced
                                                  ? null
                                                  : () async {
                                                      await currentLinkService
                                                          .syncData(
                                                              state.links,
                                                              state.currentUser!
                                                                  .$id);
                                                      setState(() {});
                                                      // print("how");
                                                      //             context
                                                      // .read<AppBloc>()
                                                      // .add(const SyncLinks());
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
                                  }),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 14),
                              //   child: CustomButton(
                              //     text: "Save",
                              //     shouldShowLoader: true,
                              //     onTap: () async {
                              //       await Future.delayed(
                              //           const Duration(seconds: 1), () {
                              //         print('done with the future');
                              //       });
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom < 10
                                    ? 10
                                    : MediaQuery.of(context).padding.bottom + 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  validateDeleteLink(String linkId) {
    if (LinkModel.createdLinks.contains(linkId)) {
      LinkModel.createdLinks.remove(linkId);
      if (LinkModel.createdLinks.isEmpty &&
          LinkModel.deletedLinks.isEmpty &&
          LinkModel.updatedLinks.isEmpty) {
        setState(() {
          LinkModel.linksSynced = true;
        });
      }
      return;
    }
    if (LinkModel.updatedLinks.contains(linkId)) {
      LinkModel.createdLinks.remove(linkId);
      if (LinkModel.createdLinks.isEmpty &&
          LinkModel.deletedLinks.isEmpty &&
          LinkModel.updatedLinks.isEmpty) {
        setState(() {
          LinkModel.linksSynced = true;
        });
      }
      return;
    }
    if (LinkModel.linksSynced) {
      setState(() {
        LinkModel.linksSynced = false;
      });
    }
    LinkModel.deletedLinks.add(linkId);
  }

  validateUpdate(String linkId) {
    print(linkId);
    if (LinkModel.createdLinks.contains(linkId) ||
        LinkModel.deletedLinks.contains(linkId) ||
        LinkModel.updatedLinks.contains(linkId)) {
          print("here");
      return;
    }
    if (LinkModel.createdLinks.isEmpty &&
        LinkModel.deletedLinks.isEmpty &&
        LinkModel.updatedLinks.isEmpty) {
      setState(() {
        LinkModel.linksSynced = true;
      });
    }
    if (LinkModel.linksSynced) {
      setState(() {
        LinkModel.linksSynced = false;
      });
    }
    LinkModel.updatedLinks.add(linkId);
  }
}
