import 'package:cinema_scope/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkMode = ThemeData(
    scaffoldBackgroundColor: AppColor.backgroundDark,
    highlightColor: AppColor.accentDark,
  );
  static ThemeData lightMode = ThemeData(
    scaffoldBackgroundColor: AppColor.backgroundLight,
    highlightColor: AppColor.accentLight,
  );
}
