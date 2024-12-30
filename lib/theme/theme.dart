// element specific colors are in colors.dart

import 'package:flutter/material.dart';

// ==================================================================================================
ThemeData lightMode = ThemeData(
  fontFamily: 'Montserrat',
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // grey 100
  colorScheme: ColorScheme(
    primary: Color(0xFF124870), // Pastel blue for primary actions
    primaryContainer: Color(0xFFD9E6F2), // Lighter pastel blue for containers
    secondary: Color(0xFF7E577F), // Pastel pink/purple for secondary actions
    secondaryContainer: Color(0xFFF5E3F2), // Lighter pastel pink for containers
    surface: Colors.white, // Background for cards, dialogs, etc.
    error: Color(0xFFFF4B4B), // Red for error states
    onPrimary: Colors.white, // Text/icons on primary
    onSecondary: Colors.white, // Text/icons on secondary
    onSurface: Colors.black, // Text/icons on surface
    onError: Colors.white, // Text/icons on error
    brightness: Brightness.light, // Light theme brightness
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
  primary: Color(0xFF1C8FDF), // Pastel blue for primary actions
    primaryContainer: Color(0xFF3C4A5F), // Darker pastel blue for containers
    secondary: Color(0xFFFEADFD), // Pastel pink/purple for secondary actions
    secondaryContainer: Color(0xFF4A4A4A), // Darker pastel pink for containers
    surface: Color(0xFF212121), // Background for cards, dialogs, etc.
    error: Color(0xFFFF4B4B), // Red for error states
    onPrimary: Colors.black, // Text/icons on primary
    onSecondary: Colors.black, // Text/icons on secondary
    onSurface: Colors.white, // Text/icons on surface
    onError: Colors.black, // Text/icons on error
    brightness: Brightness.dark, // Dark theme brightness
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