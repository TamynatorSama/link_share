import 'package:flutter/material.dart';
import 'package:link_share/shared/shared_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool inverted;
  const CustomButton({super.key, required this.text, this.inverted = false ,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: inverted? BoxDecoration(
            border: Border.all(width: 1,color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(10)) :BoxDecoration(
            color: onTap ==null ?const Color(0xFF633CFF).withOpacity(0.4) : AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: AppTheme.buttonText.copyWith(color: inverted?AppTheme.primaryColor:null),
        ),
      ),
    );
  }
}
