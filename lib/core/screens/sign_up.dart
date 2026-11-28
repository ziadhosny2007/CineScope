import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/validator.dart';
import 'package:cinema_scope/core/widget/btn.dart';
import 'package:cinema_scope/core/widget/dark_btn.dart';
import 'package:cinema_scope/core/widget/loading_btn.dart';
import 'package:cinema_scope/core/widget/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final cPassword = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final cPasswordFocus = FocusNode();

  bool isLoading = false;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    cPassword.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    cPasswordFocus.dispose();
    super.dispose();
  }

  String _authMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'operation-not-allowed':
        return 'Email sign-up is not enabled.';
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

  Future<void> _signUp() async {
    if (isLoading) return;
    if (!form.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text,
          );
      final name = fullName.text.trim();
      await credential.user?.updateDisplayName(name);
      try {
        await credential.user?.sendEmailVerification();
      } catch (e) {
        debugPrint('verification email failed: $e');
        // مش مشكلة، يقدر يعمل Resend من صفحة VerifyEmail
      }
      await credential.user?.reload();
      await SharedPreferencesAsync().setString('username', name);

      TextInput.finishAutofillContext();
      if (mounted) context.go(AppRouter.verifyEmail);
    } on FirebaseAuthException catch (e) {
      TextInput.finishAutofillContext(shouldSave: false);
      if (mounted) _showMessage(_authMessage(e.code));
    } catch (e) {
      debugPrint('signup error: $e');
      if (mounted) _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
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

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/o1.jpg",
                    fit: BoxFit.cover,
                    height: 200.h,
                    width: double.infinity,
                  ),
                ),

                25.verticalSpace,

                Text(
                  "Start your story.",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 30),
                ),

                5.verticalSpace,

                Text(
                  "A world of cinema, tailored to you.",
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                25.verticalSpace,

                AutofillGroup(
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Full name", style: labelStyle),
                        10.verticalSpace,
                        TextFiledWidget(
                          hint: "Full name",
                          controller: fullName,
                          validator: Validators.name,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => emailFocus.requestFocus(),
                          autofillHints: const [AutofillHints.name],
                        ),
                        10.verticalSpace,

                        Text("Email address", style: labelStyle),
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

                        Text("Password", style: labelStyle),
                        10.verticalSpace,
                        TextFiledWidget(
                          hint: "Enter your password",
                          isSecure: true,
                          controller: password,
                          focusNode: passwordFocus,
                          validator: Validators.newPassword,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              cPasswordFocus.requestFocus(),
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                        10.verticalSpace,

                        Text("Confirm Password", style: labelStyle),
                        10.verticalSpace,
                        TextFiledWidget(
                          hint: "Confirm your password",
                          isSecure: true,
                          controller: cPassword,
                          focusNode: cPasswordFocus,
                          validator: Validators.confirmPassword(password),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _signUp(),
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                        8.verticalSpace,
                        Text(
                          "Use at least 8 characters, a number and a symbol.",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

                16.verticalSpace,
                Center(
                  child: isLoading
                      ? LoadingBtn()
                      : Btn(title: "Create account", onPressed: _signUp),
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
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRouter.login);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontSize: 13),
                        ),
                        Text(
                          "  Log in",
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
                10.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
