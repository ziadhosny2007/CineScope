import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/widget/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Map> pages = [
    {
      "image": "assets/images/o1.jpg",
      "imageTitle": "CURATED FOR YOU",
      "title1": "Less scrolling.",
      "title2": "More great stories.",

      "subTitle":
          "Discover remarkable films, hidden gems and your next all-time favorite.",
      "btn": "Continue",
    },

    {
      "image": "assets/images/o2.jpg",
      "imageTitle": "MADE FOR MOVIE NIGHTS",
      "title1": "Your taste.",
      "title2": "Your watchlist.",
      "subTitle":
          "Save the films that catch your eye. Make every movie night a good one.",
      "btn": "Continue",
    },
    {
      "image": "assets/images/o3.jpg",
      "imageTitle": "FIND YOUR FILM",
      "title1": "Find your kind.",
      "title2": "Every time.",
      "subTitle":
          "Filter by genre, year and rating. Less time deciding. More time watching.",
      "btn": "Get started",
    },
  ];
  PageController? controller;

  int index = 0;
  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 6.h,
        crossAxisAlignment: .center,
        children: [
          SizedBox(
            height: 506.h,
            width: 390.w,
            child: PageView.builder(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, i) {
                return OnboardingImage(
                  path: pages[i]["image"],
                  imageTitle: pages[i]["imageTitle"],
                );
              },
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "${pages[index]["title1"]}\n"),
                TextSpan(text: "${pages[index]["title2"]}"),
              ],
            ),
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: .bold,
              color: Theme.of(context).hintColor,
            ),
          ),
          SizedBox(
            width: .9.sw,
            child: Text(
              " ${pages[index]["subTitle"]}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 20.w),
            child: Row(
              mainAxisAlignment: .start,
              children: [
                AnimatedSmoothIndicator(
                  activeIndex: index,
                  count: 3,

                  effect: ExpandingDotsEffect(
                    dotHeight: 10.h,
                    dotWidth: 10.h,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 14.w),
          child: Btn(
            title: pages[index]["btn"],
            onPressed: () async {
              if (index == pages.length - 1) {
                SharedPreferencesAsync sharedPreferencesAsync =
                    SharedPreferencesAsync();
                await sharedPreferencesAsync.setBool("isFirst", false);
                context.go(AppRouter.login);
              } else {
                controller?.animateToPage(
                  index + 1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable

// ignore: must_be_immutable
class OnboardingImage extends StatelessWidget {
  OnboardingImage({super.key, required this.path, required this.imageTitle});
  String path;
  String imageTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 506.h,
      width: 390.w,

      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30.w,
            right: 30.w,
            child: TextButton(
              onPressed: () {
                context.go(AppRouter.login);
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: .w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30.w,
            left: 30.w,
            child: Container(
              height: 30.h,
              width: 128.w,
              alignment: .center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Color(0xff0D0F12),
              ),
              child: Text(
                imageTitle,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: .w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
