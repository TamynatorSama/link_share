// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/bloc/actions/app_actions.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/screens/linkpage/link_page.dart';
import 'package:link_share/screens/preview.dart';
import 'package:link_share/screens/profile/profile_screen.dart';
import 'package:link_share/shared/custom_loader.dart';
import 'package:link_share/shared/shared_theme.dart';
import 'package:link_share/utils/keyboard_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController();

  @override
  void initState() {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => CustomLoader.showLoader(context));
    context.read<AppBloc>().add(InitUser(context));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    keyboardState.updateKeyBoardState(context);
    super.didChangeDependencies();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset("assets/images/logo-devlinks-small.svg"),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => controller.jumpToPage(0),
              child: Container(
                width: 70,
                height: 45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: selectedIndex != 0 ? null : const Color(0xFFEFEBFF),
                    borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  'assets/images/icon-link.svg',
                  color: selectedIndex != 0 ? null : AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                controller.jumpToPage(1);
              },
              child: Container(
                width: 70,
                height: 45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: selectedIndex != 1 ? null : const Color(0xFFEFEBFF),
                    borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  'assets/images/icon-profile-details-header.svg',
                  color: selectedIndex != 1 ? null : AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> const Preview())),
            child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              width: 60,
              height: 40,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                'assets/images/icon-preview-header.svg',
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          )],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                selectedIndex = value;
                setState(() {});
              },
              children: const [LinkPage(), ProfileScreen()],
            ),
          )
        ],
      ),
    );
  }
}
