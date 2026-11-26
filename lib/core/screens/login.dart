import 'dart:async';

import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/validator.dart';
import 'package:cinema_scope/core/widget/btn.dart';
import 'package:cinema_scope/core/widget/dark_btn.dart';
import 'package:cinema_scope/core/widget/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
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
    // اتشال authStateChanges من هنا عشان ميقطعش الأنيميشن
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

    // للتأكد إن الأسماء مطابقة لملف Rive (لو طلع null يبقى الاسم غلط)
    debugPrint('rive inputs -> success=$trigSuccess fail=$trigFail');
  }

  void _onEmailFocusChanged() {
    isChecking?.value = emailFocus.hasFocus;
    if (emailFocus.hasFocus) _onEmailChanged();
  }

  void _onEmailChanged() {
    numLook?.value = (email.text.length * 2.0).clamp(0, 100).toDouble();
  }

  void _onPasswordFocusChanged() {
    isHandsUp?.value = passwordFocus.hasFocus;
  }

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Email or password is incorrect.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _login() async {
    if (isLoading) return;

    if (!form.currentState!.validate()) {
      trigFail?.fire();
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      TextInput.finishAutofillContext();

      trigSuccess?.fire();
      // مدة أنيميشن النجاح، ظبطها حسب ملف الـ .riv
      await Future.delayed(const Duration(milliseconds: 1500));

      final name = FirebaseAuth.instance.currentUser?.displayName;
      await SharedPreferencesAsync().setString("username", name ?? "");

      if (mounted) context.go(AppRouter.home);
    } on FirebaseAuthException catch (e) {
      trigFail?.fire();
      TextInput.finishAutofillContext(shouldSave: false);
      if (mounted) _showMessage(_authMessage(e.code));
    } catch (e) {
      trigFail?.fire();
      debugPrint('login error: $e');
      if (mounted) _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final value = email.text.trim();
    if (Validators.email(value) != null) {
      _showMessage('Enter your email first.');
      emailFocus.requestFocus();
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: value);
      if (mounted) _showMessage('Reset link sent. Check your email.');
    } on FirebaseAuthException catch (e) {
      if (mounted) _showMessage(_authMessage(e.code));
    }
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
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    );

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
                      "Cinema Scope",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                25.verticalSpace,

                // Rive Animation
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
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
                          debugPrint('rive failed: ${state.error}');
                          return const Center(
                            child: Icon(Icons.movie_outlined),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),

                25.verticalSpace,

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

                AutofillGroup(
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email address", style: titleStyle),
                        10.verticalSpace,
                        TextFiledWidget(
                          hint: "alex@email.com",
                          controller: email,
                          focusNode: emailFocus,
                          validator: Validators.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                          autofillHints: const [AutofillHints.email],
                        ),
                        10.verticalSpace,
                        Text("Password", style: titleStyle),
                        10.verticalSpace,
                        TextFiledWidget(
                          hint: "Enter your password",
                          isSecure: true,
                          controller: password,
                          focusNode: passwordFocus,
                          validator: Validators.requiredPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          autofillHints: const [AutofillHints.password],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _resetPassword,
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
                      ],
                    ),
                  ),
                ),

                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Btn(title: "Login", onPressed: _login),
                ),
                8.verticalSpace,

                Row(
                  children: [
                    const Expanded(child: Divider(height: 1)),
                    Expanded(
                      child: Text(
                        " or continue with",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const Expanded(child: Divider(height: 1)),
                  ],
                ),
                8.verticalSpace,

                Center(
                  child: DarkBtn(title: "Google", onPressed: () {}),
                ),
                20.verticalSpace,
                Center(
                  child: TextButton(
                    onPressed: () => context.push(AppRouter.signUp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New to Cinema scope?  ",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontSize: 13),
                        ),
                        Text(
                          "Create an account",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 13,
                                color: Theme.of(context).highlightColor,
                              ),
                        ),
                      ],
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
