// currently only used in news page

import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static final CustomSnackBar _instance = CustomSnackBar._internal();

  factory CustomSnackBar(BuildContext context) {
    return _instance;
  }

  CustomSnackBar._internal();

  // custom snackbar component for displaying messages
  void show(
      BuildContext context, TickerProvider tickerProvider, String message) {
    if (BaseController.to.isCustomSnackBarVisible.value || !context.mounted) {
      return;
    }

    BaseController.to.isCustomSnackBarVisible.value = true;

    final overlay = Overlay.of(context);
    // animation controller
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync:
          tickerProvider, // replace this if you encounter a TickerProvider issue
    );

    // animation curve effect
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutExpo,
    );

    // snackbar appearance
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              bottom: Tween<double>(begin: -40, end: 12).evaluate(animation),
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.9,
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    // Ensures the content stays in the center of the screen
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(26, 0, 0, 0),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // insert overlay entry
    overlay.insert(overlayEntry);

    // start animation
    animationController.forward();

    // reverse animation, remove overlay, and reset visibility flag
    Future.delayed(const Duration(seconds: 1), () {
      animationController.reverse().then((_) {
        overlayEntry.remove();
        animationController.dispose();
        BaseController.to.isCustomSnackBarVisible.value = false;
      });
    });
  }
}
