import 'package:flutter/material.dart' show BuildContext,ChangeNotifier,MediaQuery;

KeyboardChecker keyboardState = KeyboardChecker();

class KeyboardChecker extends ChangeNotifier {
  bool keyboardIsOpened = false;

  updateKeyBoardState(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      keyboardIsOpened = true;
    } else {
      keyboardIsOpened = false;
    }
    notifyListeners();
  }
}
