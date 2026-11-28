import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingBtn extends StatefulWidget {
  const LoadingBtn({super.key});

  @override
  State<LoadingBtn> createState() => _LoadingBtnState();
}

class _LoadingBtnState extends State<LoadingBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: .center,
        spacing: 4,
        children: [
          Text(
            "Loading...",
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            size: 40,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
    );
  }
}
