import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Btn extends StatelessWidget {
  Btn({super.key, required this.title, required this.onPressed});
  Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330.w,
      height: 52,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Theme.of(context).highlightColor,
        onPressed: onPressed,

        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );
  }
}
