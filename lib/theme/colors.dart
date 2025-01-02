import 'package:flutter/material.dart';

class AppColors {
  // HomePage =================================================

  // Light
  static const Color lightTitleTextColor = Color.fromARGB(255, 38, 38, 38);

  static const Color lightRefreshList = Color.fromARGB(255, 38, 38, 38);
  static const Color lightAddItem = Color(0xFF124870);
  static const Color lightDeleteItem = Color(0xFF7E577F);

  static const Color lightSearchInputTextColor = Colors.black;
  static const Color lightSearchInputCursorColor = Color(0xFF124870);
  static const Color lightSearchInputFillColor = Colors.white;
  static const Color lightSearchInputLabelColor = Colors.black;
  static const Color lightSearchInputIconColor = Colors.black;
  static const Color lightSearchInputFocusedBorderSideColor = Colors.black;

  static const Color lightSearchButtonBorderColor =
      Color.fromARGB(255, 41, 41, 41);
  static const Color lightSearchButtonForegroundColor = Colors.white;
  static const Color lightSearchButtonIconColor =
      Color.fromARGB(255, 37, 37, 37);

  static const Color lightItemCardColor = Colors.white;
  static const Color lightItemTitleTextColor = Colors.black;
  static const Color lightItemSubtitleTextColor = Colors.black;

  // Dark
  static const Color darkTitleTextColor = Colors.white;

  static const Color darkRefreshList = Colors.white;
  static const Color darkAddItem = Color(0xFF1C8FDF);
  static const Color darkDeleteItem = Color(0xFFFEADFD);

  static const Color darkSearchInputTextColor = Colors.white;
  static const Color darkSearchInputCursorColor = Color(0xFF1C8FDF);
  static const Color darkSearchInputFillColor = Color.fromRGBO(33, 33, 33, 1);
  static const Color darkSearchInputLabelColor = Colors.white;
  static const Color darkSearchInputIconColor = Colors.white;
  static const Color darkSearchInputFocusedBorderSideColor = Colors.white;

  static const Color darkSearchButtonBorderColor = Colors.white;
  static const Color darkSearchButtonForegroundColor =
      Color.fromRGBO(33, 33, 33, 1);
  static const Color darkSearchButtonIconColor = Colors.white;

  static const Color darkItemCardColor = Color.fromRGBO(33, 33, 33, 1);
  static const Color darkItemTitleTextColor = Colors.white;
  static const Color darkItemSubtitleTextColor = Colors.white;

  // Device theme-s hamaarch tohirson ungu uguh method
  static Color titleTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkTitleTextColor
        : lightTitleTextColor;
  }

  static Color refreshListColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkRefreshList : lightRefreshList;
  }

  static Color addItemColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkAddItem : lightAddItem;
  }

  static Color deleteItemColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkDeleteItem : lightDeleteItem;
  }

  static Color searchInputTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputTextColor
        : lightSearchInputTextColor;
  }

  static Color searchInputFillColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputFillColor
        : lightSearchInputFillColor;
  }

  static Color searchInputCursorColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputCursorColor
        : lightSearchInputCursorColor;
  }

  static Color searchInputLabelColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputLabelColor
        : lightSearchInputLabelColor;
  }

  static Color searchInputIconColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputIconColor
        : lightSearchInputIconColor;
  }

  static Color searchInputFocusedBorderSideColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchInputFocusedBorderSideColor
        : lightSearchInputFocusedBorderSideColor;
  }

  static Color searchButtonBorderColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchButtonBorderColor
        : lightSearchButtonBorderColor;
  }

  static Color searchButtonForegroundColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchButtonForegroundColor
        : lightSearchButtonForegroundColor;
  }

  static Color searchButtonIconColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSearchButtonIconColor
        : lightSearchButtonIconColor;
  }

  static Color itemCardColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkItemCardColor
        : lightItemCardColor;
  }

  static Color itemTitleTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkItemTitleTextColor
        : lightItemTitleTextColor;
  }

  static Color itemSubtitleTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkItemSubtitleTextColor
        : lightItemSubtitleTextColor;
  }

  // NewsPage =================================================

  // Light
  static const Color lightNextButtonColor = Color(0xFF124870);
  static const Color lightPrevButtonColor = Color.fromARGB(255, 97, 66, 98);
  static const Color lightRefreshButtonColor = Color.fromARGB(255, 38, 38, 38);
  static const Color lightShareButtonColor = Color.fromARGB(255, 38, 38, 38);

  static const Color lightCustomSnackBarTextColor = Colors.black;
  static const Color lightCustomSnackBarBackgroundColor = Colors.white;

  // Dark
  static const Color darkNextButtonColor = Color(0xFF124870);
  static const Color darkPrevButtonColor = Color.fromARGB(255, 97, 66, 98);
  static const Color darkRefreshButtonColor = Color.fromARGB(255, 38, 38, 38);
  static const Color darkShareButtonColor = Color.fromARGB(255, 38, 38, 38);

  static const Color darkCustomSnackBarTextColor = Colors.black;
  static const Color darkCustomSnackBarBackgroundColor = Colors.white;

  // Device theme-s hamaarch tohirson ungu uguh method
  static Color nextButtonColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkNextButtonColor
        : lightNextButtonColor;
  }

  static Color prevButtonColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkPrevButtonColor
        : lightPrevButtonColor;
  }

  static Color refreshButtonColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkRefreshButtonColor
        : lightRefreshButtonColor;
  }

  static Color shareButtonColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkShareButtonColor
        : lightShareButtonColor;
  }

  static Color customSnackBarTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkCustomSnackBarTextColor
        : lightCustomSnackBarTextColor;
  }

  static Color customSnackBarBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkCustomSnackBarBackgroundColor
        : lightCustomSnackBarBackgroundColor;
  }
}
