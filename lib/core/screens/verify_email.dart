import 'dart:async';

import 'package:cinema_scope/core/routes/app_router.dart';
import 'package:cinema_scope/core/widget/btn.dart';
import 'package:cinema_scope/core/widget/dark_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isLoading = false;
  late final StreamSubscription<User?> _authSub;
  late String email;
  Timer? _verificationTimer;
  bool isChecking = false;
  Future<void> checkEmailVerification() async {
    if (isChecking) return;

    isChecking = true;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      await user.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        _verificationTimer?.cancel();

        if (!mounted) return;

        context.go(AppRouter.home);
      }
    } catch (e) {
      debugPrint('Verification check failed: $e');
    } finally {
      isChecking = false;
    }
  }

  @override
  void initState() {
    email = FirebaseAuth.instance.currentUser!.email.toString();
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerification(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: .start,
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
                80.verticalSpace,
                Column(
                  crossAxisAlignment: .center,
                  spacing: 10.h,
                  children: [
                    Center(
                      child: Container(
                        height: 85.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        alignment: .center,
                        child: Icon(
                          Icons.mail_outline,
                          color: Theme.of(context).highlightColor,
                          size: 32,
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    Text(
                      "Check your inbox",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 28.sp),
                    ),
                    5.verticalSpace,
                    Text(
                      "Verify your Account",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                    ),
                    5.verticalSpace,

                    Text(
                      email,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                    ),
                    5.verticalSpace,

                    Text(
                      textAlign: .center,
                      "Follow the link in your email to Verify your Account. The link expires in 15 minutes.",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: SizedBox(
            height: 200.h,
            child: Column(
              mainAxisSize: .min,
              children: [
                Btn(
                  title: "Open email",
                  onPressed: () async {
                    final Uri gmailUri = Uri.parse('googlegmail://');

                    if (await canLaunchUrl(gmailUri)) {
                      await launchUrl(
                        gmailUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      await launchUrl(
                        Uri.parse('https://mail.google.com/'),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                5.verticalSpace,

                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              await user.sendEmailVerification();

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Verification email sent successfully',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint('Verification email failed: $e');
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Didn’t receive it? Resend email",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 13.sp,
                                color: Theme.of(context).highlightColor,
                              ),
                        ),
                ),
                5.verticalSpace,
                DarkBtn(
                  title: "Back to log in",
                  onPressed: () {
                    context.go(AppRouter.login);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
