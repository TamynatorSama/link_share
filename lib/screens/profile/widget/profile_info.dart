
import 'package:flutter/material.dart';
import 'package:link_share/shared/custom_input.dart';

class ProfileInfo extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  const ProfileInfo({Key? key,required this.emailController,required this.firstNameController,required this.lastNameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
      decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        runSpacing: 20,
        children: [
          CustomInputField(
              label: "First name*",
              hint: "First Name",
              controller: firstNameController),
          CustomInputField(
              hint: "Last Name",
              label: "Last name*",
              controller: lastNameController),
          CustomInputField(label: "Email", controller: emailController,readOnly: true,)
        ],
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     SvgPicture.asset("assets/images/illustration-empty.svg",height: (MediaQuery.of(context).size.height * 0.15).clamp(70, 150),),
      //     const SizedBox(height: 20,),
      //     Text("Let’s get you started",textAlign: TextAlign.center,style: AppTheme.headerText,),
      //     const SizedBox(height: 24,),
      //     Text("Use the “Add new link” button to get started. Once you have more than one link, you can reorder and edit them. We’re here to help you share your profiles with everyone!",textAlign: TextAlign.center,style: AppTheme.bodyText.copyWith(fontSize: 17),),
      //   ],
      // ),
    );
  }
}
