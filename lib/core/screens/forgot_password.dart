import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  alignment: .center,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).hintColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
