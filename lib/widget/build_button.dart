import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onclick;
  final IconData? icon;

  const BuildButton({
    super.key,
    required this.onclick,
    required this.text,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = isDarkMode ? Colors.grey.shade800 : Colors.blueGrey.shade100;
    final buttonBgColor = color ?? defaultBgColor;
    final buttonTextColor = color == null ? (isDarkMode ? Colors.white : Colors.black) : Colors.white;

    final buttonSize = 75.w;
    final iconSize = 25.sp;
    final fontSize = 25.sp;
    final padding = 5.w;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            minimumSize: Size(buttonSize, buttonSize),
            maximumSize: Size(buttonSize, buttonSize),
            padding: EdgeInsets.zero,
            backgroundColor: buttonBgColor,
            elevation: 5,
            shadowColor: isDarkMode ? Colors.black45 : Colors.grey.shade400,
          ),
          onPressed: onclick,
          child: icon != null
              ? Icon(
            icon,
            size: iconSize,
            color: buttonTextColor,
          )
              : Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}