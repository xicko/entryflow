import 'package:flutter/material.dart';
// import '../colors/buttons.dart';

// ==================================================================================================
ThemeData lightMode = ThemeData(
  fontFamily: 'Montserrat',
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // grey 100
  colorScheme: ColorScheme(
    primary: Color(0xFF124870),
    primaryContainer: Colors.white,
    secondary: Color(0xFF7E577F),
    secondaryContainer: Color.fromARGB(255, 41, 41, 41),
    surface: Colors.white,
    error: Colors.black,
    onPrimary: Color.fromARGB(255, 38, 38, 38),
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onError: Colors.black,
    brightness: Brightness.light
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 38, 38, 38),
  ),

  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.grey[900],
    backgroundColor: Colors.white,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey[900],
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    splashColor: Color.fromARGB(255, 213, 213, 213),
  ),

  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      color: Colors.black,
    )
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.white,
    contentTextStyle: TextStyle(color: Color.fromARGB(255, 38, 38, 38)),
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
);



// ==================================================================================================
ThemeData darkMode = ThemeData(
  fontFamily: 'Montserrat',
  scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20), // gray
  colorScheme: ColorScheme(
    primary: Color(0xFF1C8FDF),
    primaryContainer: Colors.grey[900],
    secondary: Color(0xFFFEADFD),
    secondaryContainer: Colors.white,
    surface: Color.fromRGBO(33, 33, 33, 1),
    error: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.white,
  ),

  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.white,
    backgroundColor: Colors.grey[900],
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.grey[900],
    unselectedItemColor: Colors.white,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    splashColor: Color.fromARGB(255, 213, 213, 213),
  ),

  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      color: Colors.black,
    )
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[900],
    contentTextStyle: TextStyle(
      color: Colors.white
    ),
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
);