import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/shared/link_to_svg.dart';
import 'package:link_share/shared/shared_theme.dart';

class CustomDropDown extends StatefulWidget {
  final InputDecoration decoration;
  final String label;
  final Function(String changeId)? additionalOnchangeFunction;
  final String? svgPrefixIcon;
  final String chosenLogo;
  final String linkId;
  const CustomDropDown(
      {super.key,
      required this.label,
      this.svgPrefixIcon,
      required this.chosenLogo,
      this.additionalOnchangeFunction,
      required this.linkId,
      this.decoration = const InputDecoration()});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late FocusNode node;
  bool isFocused = false;
  String? value;

  @override
  void initState() {
    value = widget.chosenLogo.isEmpty?null:widget.chosenLogo;
    node = FocusNode()
      ..addListener(() {
        checkFocusState();
      });
    super.initState();
  }

  checkFocusState() {
    if (node.hasFocus) {
      isFocused = true;
    } else {
      isFocused = false;
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.bodyText.copyWith(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Material(
          shadowColor: isFocused
              ? AppTheme.primaryColor.withOpacity(0.8)
              : Colors.transparent,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: isFocused ? 5 : 0,
          child: DropdownButtonFormField(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            focusNode: node,
            value: value,
            // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            menuMaxHeight: 150,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: widget.decoration.copyWith(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              prefixIcon: widget.svgPrefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SvgPicture.asset(widget.svgPrefixIcon!),
                    ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(width: 1, color: AppTheme.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xffD9D9D9))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xffD9D9D9))),
            ),
            style: AppTheme.bodyText,
            onChanged: (value) {
              this.value = value;
              if(widget.additionalOnchangeFunction !=null){
                widget.additionalOnchangeFunction!(widget.linkId);
              }
              context.read<AppBloc>().state.links.firstWhere((element) => widget.linkId == element.id).linkName = value ?? "";
            },
            items: [
              ...List.generate(
                  links.length,
                  (index) => DropdownMenuItem(
                      value: links.entries.elementAt(index).key,
                      child: Row(
                        children: [
                          links.entries.elementAt(index).value,
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            links.entries.elementAt(index).key,
                            style: AppTheme.bodyText.copyWith(fontSize: 18),
                          )
                        ],
                      )
                      ),
                      )
              // DropdownMenuItem(

              //   )
            ],
          ),
        ),
      ],
    );
  }
}
