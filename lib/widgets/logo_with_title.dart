import 'package:entryflow/theme/colors.dart';
import 'package:flutter/material.dart';

class LogoWithTitle extends StatelessWidget {
  const LogoWithTitle({super.key});

  @override
  Widget build(BuildContext context) {
    // DarkMode assan uyd zarim UI elementuudiig uurchluhud ashiglah flag
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    // Logo and Name
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
            // DarkMode assan tohioldold logonii uur huvilbariig haruulna
            image: isDarkMode
                ? AssetImage('assets/logoDark.png')
                : AssetImage('assets/logoLight.png'),
            width: 80,
            height: 80),
        Text(
          'EntryFlow',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 36,
            color: AppColors.titleTextColor(Theme.of(context).brightness),
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
