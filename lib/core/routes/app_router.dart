import 'package:cinema_scope/core/screens/home.dart';
import 'package:cinema_scope/core/screens/login.dart';
import 'package:cinema_scope/core/screens/onboarding.dart';
import 'package:cinema_scope/core/screens/sign_up.dart';
import 'package:cinema_scope/core/screens/splash.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static String splash = "/splash";
  static String onboarding = "/onboarding";
  static String login = "/login";
  static String signUp = "/signUp";
  static String home = "/home";

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const Splash()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const Onboarding(),
      ),
      GoRoute(path: home, builder: (context, state) => const Home()),
      GoRoute(path: login, builder: (context, state) => const Login()),
      GoRoute(path: signUp, builder: (context, state) => const SignUp()),
    ],
  );
}
