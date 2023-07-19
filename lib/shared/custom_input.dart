import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:link_share/shared/shared_theme.dart';

class CustomInputField extends StatefulWidget {
  final InputDecoration decoration;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? svgPrefixIcon;
  final bool isPassword;
  final String? Function(String? ob)? validator;
  const CustomInputField(
      {super.key,
      required this.label,
      this.hint,
      this.svgPrefixIcon,
      this.validator,
      required this.controller,
      this.isPassword = false,
      this.decoration = const InputDecoration()});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode node;
  bool isFocused = false;


  @override
  void initState() {
    node = FocusNode()..addListener(() { checkFocusState();}); 
    super.initState();
  }

  checkFocusState(){
    if(node.hasFocus){
      isFocused =true;
    }
    else{
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
          shadowColor: isFocused ?AppTheme.primaryColor.withOpacity(0.8):Colors.transparent,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: isFocused ?5:0,
          child: TextFormField(
            focusNode: node,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: const Color.fromARGB(255, 85, 85, 85),
            decoration: widget.decoration.copyWith(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              hintText: widget.hint,
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
            obscureText: widget.isPassword,
            validator: widget.validator ??
                (val) {
                  if (val!.trim().isEmpty) {
                    return "Can't be empty";
                  }
                  if (widget.isPassword) {
                    if (val.length < 8) {
                      return "Can't be less than 8 characters";
                    }
                  }
                  return null;
                },
            style: AppTheme.bodyText,
          ),
        ),
      ],
    );
  }
}
