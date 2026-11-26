import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/theme/app_theme.dart';
import 'package:cinema_scope/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          themeMode: ThemeMode.dark,
          theme: AppTheme.lightMode,
          darkTheme: AppTheme.darkMode,
        );
      },
    );
  }
}

//tmdb d98a85b061fab194b930f86ef0acc1a7
//screen util height .h ,width .w ,fontsize .sp, padding .w ,border radius .r , 30.verticalSpace, 50% width of Screen .5.sw
// android   1:325766156924:android:6603752739f0ca12032ff9
// ios       1:325766156924:ios:eed3169f31c8ec5e032ff9
