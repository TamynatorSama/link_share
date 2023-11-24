import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/models/link_model.dart';
import 'package:link_share/screens/linkpage/widget/custom_dropdown.dart';
import 'package:link_share/shared/custom_input.dart';
import 'package:link_share/shared/shared_theme.dart';

class LinkEditor extends StatefulWidget {
  final LinkModel model;
  final int index;
  final Function() remove;
  final Function(String linkId) update;
  const LinkEditor(
      {super.key,
      required this.model,
      required this.remove,
      required this.update,
      required this.index});

  @override
  State<LinkEditor> createState() => _LinkEditorState();
}

class _LinkEditorState extends State<LinkEditor> {
  late TextEditingController linkController;
  @override
  void initState() {
    linkController = TextEditingController(text: widget.model.linkUrl)..addListener(updateLinkUrl);
    super.initState();
  }


  @override
  void dispose() {
    linkController.removeListener(updateLinkUrl);
    linkController.dispose();
    super.dispose();
  }

  updateLinkUrl(){
    context.read<AppBloc>().state.links.firstWhere((element) => widget.model.id == element.id).linkUrl = linkController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 30),
      decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/icon-drag-and-drop.svg",
                    width: 16,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Link #${widget.index}",
                    style: AppTheme.headerText
                        .copyWith(fontSize: 19, color: const Color(0xFF737373)),
                  )
                ],
              ),
              TextButton(
                onPressed: widget.remove,
                child: Text(
                  "Remove",
                  style: AppTheme.bodyText
                      .copyWith(fontSize: 18, color: const Color(0xFF737373)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          CustomDropDown(
            label: "Platform",
            chosenLogo: widget.model.linkName,
            linkId: widget.model.id,
            additionalOnchangeFunction: widget.update,
            ),
          const SizedBox(
            height: 25,
          ),
          CustomInputField(
            label: "Link",
            controller: linkController,
            svgPrefixIcon: "assets/images/icon-link.svg",
            onChange: (value){
              widget.update(widget.model.id);
            },
            validator: (ob) {
              return null;
            },
          )
        ],
      ),
    );
  }


}
