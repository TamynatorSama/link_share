import 'dart:io';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/shared/shared_theme.dart';

class UploadImageWidget extends StatelessWidget {
  final String? image;
  final Function() uploadFunction;
  
  const UploadImageWidget({Key? key, this.image,required this.uploadFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: (MediaQuery.of(context).size.height * 0.45).clamp(300, 400),
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 16),
              child: Text(
                "Profile picture",
                style: AppTheme.bodyText.copyWith(fontSize: 18),
              ),
            ),
            InkWell(
              onTap: uploadFunction,
              child: Container(
              width: constraints.maxWidth / 1.5,
              height: constraints.maxHeight / 1.6,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color(0xFFEFEBFF),
                  image: image == null ? context.read<AppBloc>().state.image == null?null:DecorationImage(image: CachedMemoryImageProvider(context.read<AppBloc>().state.currentUser!.prefs.data["profile_id"]??"",bytes: context.read<AppBloc>().state.image),fit: BoxFit.cover):DecorationImage(image: FileImage(File(image??"")),fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10)),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/icon-upload-image.svg"),
                  Text(
                    "+ Upload Image",
                    style: AppTheme.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppTheme.primaryColor),
                  )
                ],
              ),
            ),
            
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                  "Image must be below 1024x1024px. Use PNG or JPG format.",
                  style: AppTheme.bodyText.copyWith(
                    color: const Color(0xFF737373),
                  )),
            )
          ],
        );
      }),
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
