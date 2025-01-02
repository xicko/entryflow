import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static final CustomSnackBar _instance = CustomSnackBar._internal();

  factory CustomSnackBar(BuildContext context) {
    return _instance;
  }

  CustomSnackBar._internal();

  // hereglegchid message uguh custom snackbar
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
      vsync: tickerProvider,
    );

    // animation effect
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutExpo,
    );

    // Hereglegchiin utasnii height-g huviar avah
    double screenHeight = MediaQuery.of(context).size.height;

    // Snackbar UI
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              // tween ashiglaj snackbar animation ehleh bolon tugsuhduu ymar position-d ochihiig uguv
              bottom: Tween<double>(
                      begin: -screenHeight * 0.3, end: screenHeight * 0.02)
                  .evaluate(animation),
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.9,
                child: Material(
                  color: Colors.transparent,
                  child: Center(
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

    // overlay-d overlayEntry-g nemeh
    overlay.insert(overlayEntry);

    // animation ehluuleh
    animationController.forward();

    // animation uhraaj, overlay-g hasaj, visibility flag untraav
    Future.delayed(const Duration(seconds: 1), () {
      animationController.reverse().then((_) {
        overlayEntry.remove();
        animationController.dispose();
        BaseController.to.isCustomSnackBarVisible.value = false;
      });
    });
  }
}
