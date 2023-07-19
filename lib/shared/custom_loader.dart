import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:link_share/shared/shared_theme.dart';

class CustomLoader {
  static BuildContext? dialogContext;

  static showLoader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: ((pageContext) {
          dialogContext = pageContext;
          return WillPopScope(
            onWillPop: () async=>false ,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0.15 * width,
                  width: 0.15 * width,
                  child: SpinKitSpinningLines(
                    lineWidth: 3,
                color: AppTheme.primaryColor,
                // itemBuilder: (context, index) => ,
              ),
                )
              ],
            ),
          );
        }));
  }

  static dismiss() {
    if (dialogContext != null && dialogContext!.mounted) {
      Navigator.pop(dialogContext!);
    }
  }
}
