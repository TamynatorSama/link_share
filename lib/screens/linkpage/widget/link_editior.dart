import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/screens/linkpage/widget/custom_dropdown.dart';
import 'package:link_share/shared/custom_input.dart';
import 'package:link_share/shared/shared_theme.dart';

class LinkEditor extends StatefulWidget {
  final int index;
  const LinkEditor({super.key, required this.index});

  @override
  State<LinkEditor> createState() => _LinkEditorState();
}

class _LinkEditorState extends State<LinkEditor> {


  TextEditingController linkController = TextEditingController();

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
              Text(
                "Remove",
                style: AppTheme.bodyText
                    .copyWith(fontSize: 18, color: const Color(0xFF737373)),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const CustomDropDown(label: "Platform"),
          const SizedBox(
            height: 25,
          ),
          CustomInputField(
            label: "Link",
            controller: linkController,
            svgPrefixIcon: "assets/images/icon-link.svg",
            validator: (ob) {
              return null;
            },
          )
        ],
      ),
    );
  }
}
