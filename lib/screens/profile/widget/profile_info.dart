import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/shared/custom_input.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    User? currentUser = context.read<AppBloc>().state.currentUser;
    emailController = TextEditingController(text: currentUser?.email ?? "");
    firstNameController =
        TextEditingController(text: currentUser?.name ?? "".split(" ").first);
    lastNameController =
        TextEditingController(text: currentUser?.name ?? "".split(" ").last);

    super.initState();
  }

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
          CustomInputField(label: "Email", controller: emailController)
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
