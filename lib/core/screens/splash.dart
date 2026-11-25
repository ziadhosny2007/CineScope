import 'package:animate_do/animate_do.dart';
import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPreferencesAsync sharedPreferencesAsync = SharedPreferencesAsync();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () async {
      bool? isFirst = await sharedPreferencesAsync.getBool("isFirst");
      if (isFirst == false) {
        context.go(AppRouter.login);
      } else {
        context.go(AppRouter.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: .infinity,
        height: .infinity,
        alignment: .center,

        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            opacity: .5,

            image: AssetImage("assets/images/splash1.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            FadeIn(
              delay: Duration(seconds: 1),
              duration: Duration(milliseconds: 300),
              child: Container(
                height: 84,
                width: 84,
                alignment: .center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: AppColor.accentDark,
                ),
                child: Icon(Icons.play_arrow_outlined, size: 56),
              ),
            ),
            FadeIn(
              delay: Duration(milliseconds: 500),
              duration: Duration(milliseconds: 300),
              child: Text(
                "Cinema Scope",
                style: TextStyle(
                  fontWeight: .bold,
                  fontSize: 40.sp,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            FadeIn(
              delay: Duration(seconds: 1),
              duration: Duration(milliseconds: 300),
              child: Text(
                "Find your next obsession.",
                style: TextStyle(
                  fontWeight: .w500,
                  fontSize: 15.sp,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SafeArea(
        child: Container(
          height: 100.h,
          alignment: .center,
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              FadeIn(
                delay: Duration(seconds: 1),
                duration: Duration(milliseconds: 300),
                child: LoadingAnimationWidget.progressiveDots(
                  color: AppColor.accentDark,
                  size: 40,
                ),
              ),
              Text(
                "A WORLD OF STORIES",
                style: TextStyle(
                  fontWeight: .w500,
                  fontSize: 10.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
