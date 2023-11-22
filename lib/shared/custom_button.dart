
// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:link_share/shared/shared_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool inverted;
  final bool shouldShowLoader;
  const CustomButton({super.key, required this.text, this.inverted = false ,this.onTap, this.shouldShowLoader = false});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        if(isLoading) return;
        if(widget.shouldShowLoader){
          setState(() {
          isLoading = true;
        });
        }

        if(widget.onTap != null){
          await widget.onTap!();
        }
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        height: 50,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: widget.inverted? BoxDecoration(
            border: Border.all(width: 1,color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(10)) :BoxDecoration(
            color: widget.onTap ==null ?const Color(0xFF633CFF).withOpacity(0.4) : AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: isLoading
        ? Center(
            child: Container(
              width: 23,
              height: 23,
              constraints: const BoxConstraints(maxHeight: 23,maxWidth: 23),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                   Colors.white,
                ),
              ),
            ),
          )
        :Text(
          widget.text,
          style: AppTheme.buttonText.copyWith(color: widget.inverted?AppTheme.primaryColor:null),
        ),
      ),
    );
  }
}
