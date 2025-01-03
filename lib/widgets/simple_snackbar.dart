import 'package:flutter/material.dart';

class SimpleSnackBar {
  static final SimpleSnackBar _instance = SimpleSnackBar._internal();

  factory SimpleSnackBar(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  SimpleSnackBar._internal();

  late BuildContext context;
  bool _isSimpleSnackBarVisible = false;

  void show(String message) {
    // olon snackbar negen zereg duudagdahgui bolgoh
    if (_isSimpleSnackBarVisible) return;

    _isSimpleSnackBarVisible = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            duration: Duration(seconds: 1),
            content: Center(
              child: Text(message,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            )))
        .closed
        .then((_) {
      // resetting the flag after the snackbar disappears
      _isSimpleSnackBarVisible = false;
    });
  }
}
