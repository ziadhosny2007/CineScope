import 'package:cinema_scope/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData darkMode = ThemeData(
    scaffoldBackgroundColor: AppColor.backgroundDark,
    hoverColor: AppColor.surfaceDark,
    highlightColor: AppColor.accentDark,
    focusColor: AppColor.borderDark,
    hintColor: AppColor.textDark,
    secondaryHeaderColor: AppColor.onAccentDark,
    canvasColor:AppColor.accentSoftDark ,
    textTheme: TextTheme(
      titleMedium: TextStyle(
        fontWeight: .bold,
        fontSize: 22.sp,
        color: AppColor.textDark,
      ),
      titleSmall: TextStyle(fontSize: 15.sp, color: AppColor.mutedDark),
    ),
  );
  static ThemeData lightMode = ThemeData(
    scaffoldBackgroundColor: AppColor.backgroundLight,
    focusColor: AppColor.borderLight,
    hoverColor: AppColor.surfaceLight,
    secondaryHeaderColor: AppColor.onAccentLight,
    canvasColor:AppColor.accentSoftLight ,

    highlightColor: AppColor.accentLight,
    hintColor: AppColor.textLight,
    textTheme: TextTheme(
      titleMedium: TextStyle(
        fontWeight: .bold,
        fontSize: 22.sp,
        color: AppColor.textLight,
      ),
      titleSmall: TextStyle(fontSize: 15.sp, color: AppColor.mutedLight),
    ),
  );
}
