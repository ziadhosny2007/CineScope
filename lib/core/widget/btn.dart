import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Btn extends StatelessWidget {
  const Btn({super.key, required this.title, required this.onPressed});
  final Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330.w,
      height: 52,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        color: Theme.of(context).highlightColor,
        onPressed: onPressed,

        child: Row(
          spacing: 4,
          mainAxisAlignment: .center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            Icon(
              Icons.arrow_right_alt_outlined,
              color: Theme.of(context).secondaryHeaderColor,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
