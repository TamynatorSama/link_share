import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_share/shared/shared_theme.dart';

showFeedbackToast(BuildContext context,String message,{ToastType type = ToastType.error,Duration? duration,ToastGravity gravity = ToastGravity.BOTTOM}){
  FToast toast = FToast();
  toast.init(context);
  toast.showToast(
    toastDuration: duration ?? const Duration(seconds: 3),
    gravity: gravity,
    child: Container(
      width: double.maxFinite,
    padding: const  EdgeInsets.all(15),
    margin: EdgeInsets.only(bottom: (MediaQuery.of(context).padding.bottom-20).clamp(0, 50)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Color.fromARGB(85, 158, 158, 158),
          offset: Offset(0, 0),
          spreadRadius: 1,
          blurRadius: 10
        )
      ]
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(type == ToastType.success? Icons.check_circle : Icons.error,color: type == ToastType.success? Colors.green: Colors.red,size: 24,),
            const SizedBox(width: 10,),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: type == ToastType.error ?MediaQuery.of(context).size.width * 0.6:MediaQuery.of(context).size.width * 0.65),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(type == ToastType.error?"Error":"Success",maxLines: 1,style: AppTheme.headerText.copyWith(fontSize: 18),),
                  Text(message,style:AppTheme.bodyText),
                ],
              ),
            )
          ],
        ),
       InkWell(
          onTap: ()=>toast.removeCustomToast(),
          child: const Icon(Icons.close,size: 20,)),
      ],
    ),
  )
  );
}
enum ToastType{
  error,
  success
}