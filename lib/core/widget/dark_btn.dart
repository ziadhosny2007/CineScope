import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkBtn extends StatelessWidget {
  const DarkBtn({super.key, required this.title, required this.onPressed});
  final Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330.w,
      height: 52,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Theme.of(context).focusColor),
        ),
        color: Theme.of(context).hoverColor,
        onPressed: onPressed,

        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
