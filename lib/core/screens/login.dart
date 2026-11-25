import 'package:cinema_scope/core/widget/btn.dart';
import 'package:cinema_scope/core/widget/dark_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  late final FileLoader fileLoader;

  // State Machine inputs
  BooleanInput? isChecking;
  BooleanInput? isHandsUp;
  NumberInput? numLook;
  TriggerInput? trigSuccess;
  TriggerInput? trigFail;

  @override
  void initState() {
    super.initState();

    fileLoader = FileLoader.fromAsset(
      'assets/animations/login.riv',
      riveFactory: Factory.rive,
    );

    email.addListener(_onEmailChanged);
    emailFocus.addListener(_onEmailFocusChanged);
    passwordFocus.addListener(_onPasswordFocusChanged);
  }

  void _onRiveLoaded(RiveLoaded state) {
    final sm = state.controller.stateMachine;

    isChecking = sm.boolean('isChecking');
    isHandsUp = sm.boolean('isHandsUp');
    numLook = sm.number('numLook');
    trigSuccess = sm.trigger('trigSuccess');
    trigFail = sm.trigger('trigFail');
  }

  // الدب ينظر إلى الإيميل أثناء الكتابة
  void _onEmailFocusChanged() {
    isChecking?.value = emailFocus.hasFocus;
    if (emailFocus.hasFocus) _onEmailChanged();
  }

  void _onEmailChanged() {
    // numLook تقريبًا من 0 إلى 100 حسب طول النص
    numLook?.value = (email.text.length * 2.0).clamp(0, 100).toDouble();
  }

  // الدب يغطي عينيه عند التركيز على كلمة المرور
  void _onPasswordFocusChanged() {
    isHandsUp?.value = passwordFocus.hasFocus;
  }

  @override
  void dispose() {
    email.removeListener(_onEmailChanged);
    emailFocus.removeListener(_onEmailFocusChanged);
    passwordFocus.removeListener(_onPasswordFocusChanged);

    emailFocus.dispose();
    passwordFocus.dispose();
    email.dispose();
    password.dispose();
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.verticalSpace,

                // App Logo
                Row(
                  spacing: 8,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context).highlightColor,
                      ),
                      child: const Icon(Icons.play_arrow_outlined),
                    ),
                    Text(
                      "Ciema Scope",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                25.verticalSpace,

                // Rive Animation
                SizedBox(
                  height: 200.h,
                  child: RiveWidgetBuilder(
                    fileLoader: fileLoader,
                    stateMachineSelector: StateMachineSelector.byName(
                      'Login Machine',
                    ),
                    onLoaded: _onRiveLoaded,
                    builder: (context, state) {
                      if (state is RiveLoaded) {
                        return RiveWidget(
                          controller: state.controller,
                          fit: Fit.cover,
                        );
                      }

                      if (state is RiveFailed) {
                        return Center(child: Text('Failed: ${state.error}'));
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                25.verticalSpace,

                // Welcome
                Text(
                  "Welcome back.",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 30),
                ),

                5.verticalSpace,

                Text(
                  "Good stories are waiting for you.",
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                25.verticalSpace,

                // Email
                Text(
                  "Email address",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                10.verticalSpace,

                TextFiledWidget(
                  hint: "alex@email.com",
                  controller: email,
                  focusNode: emailFocus, // خاص بصفحة الـ Login فقط
                ),

                10.verticalSpace,

                // Password
                Text(
                  "Password",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                10.verticalSpace,

                TextFiledWidget(
                  hint: "Enter your password",
                  isSecure: true,
                  controller: password,
                  focusNode: passwordFocus, // خاص بصفحة الـ Login فقط
                ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password?",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: Theme.of(context).highlightColor,
                            ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Btn(title: "Login", onPressed: () {}),
                ),
                8.verticalSpace,

                Center(
                  child: Row(
                    children: [
                      Expanded(child: Divider(height: 1)),
                      Expanded(
                        child: Text(
                          " or continue with",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Expanded(child: Divider(height: 1)),
                    ],
                  ),
                ),
                8.verticalSpace,

                Center(
                  child: DarkBtn(title: "Google", onPressed: () {}),
                ),
                20.verticalSpace,
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign Up",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// TextField Widget (reusable)
// --------------------------------------------------

class TextFiledWidget extends StatefulWidget {
  const TextFiledWidget({
    super.key,
    this.hint,
    this.isSecure = false,
    required this.controller,
    this.focusNode, // اختياري: الأماكن الأخرى مش لازم تمرره
  });

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
      height: 56.h,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode, // لو null، Flutter ينشئ واحدًا تلقائيًا
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

          focusedBorder: OutlineInputBorder(
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
