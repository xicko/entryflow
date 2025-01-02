// dahin heregleh bolomjtoi tovch widget

import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String toolTip;
  final Color foregroundColor;
  final IconData icon;
  final double iconSize;
  final double elevation;

  const CustomFloatingButton(
      {super.key,
      required this.onPressed,
      required this.toolTip,
      required this.foregroundColor,
      required this.icon,
      this.iconSize = 30,
      this.elevation = 3});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: toolTip,
      elevation: elevation,
      foregroundColor: foregroundColor,
      child: Icon(
        icon,
        size: iconSize,
      ),
    );
  }
}
