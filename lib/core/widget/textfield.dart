import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFiledWidget extends StatefulWidget {
  const TextFiledWidget({
    super.key,
    this.hint,
    this.isSecure = false,
    required this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool isSecure;
  final String? hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  @override
  State<TextFiledWidget> createState() => _TextFiledWidgetState();
}

class _TextFiledWidgetState extends State<TextFiledWidget> {
  late bool secure;

  @override
  void initState() {
    super.initState();
    secure = widget.isSecure;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofillHints: widget.autofillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: secure,
        maxLines: 1,

        textAlignVertical: TextAlignVertical.center,

        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16),

        cursorColor: Theme.of(context).hintColor,

        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).hoverColor,

          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.titleSmall,

          suffixIcon: widget.isSecure
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      secure = !secure;
                    });
                  },
                  icon: Icon(secure ? Icons.visibility_off : Icons.visibility),
                )
              : null,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),
        ),
      ),
    );
  }
}
