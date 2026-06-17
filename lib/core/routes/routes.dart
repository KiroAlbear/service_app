// ignore_for_file: public_member_api_docs, sort_constructors_first, always_specify_types
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service/features/home/home_page.dart';
import 'package:service/features/login/login_page.dart';

class Routes {
  Routes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // SCREENS
  static const String loginScreen = '/';
  static const String homeScreen = '/homeScreen';

  static final GoRouter goRouter = GoRouter(
    initialLocation: loginScreen,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      GoRoute(
        path: loginScreen,
        name: loginScreen,
        parentNavigatorKey: rootNavigatorKey,

        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, const LoginPage()),
      ),
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        parentNavigatorKey: rootNavigatorKey,

        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, const HomePage()),
      ),
    ],
  );

  static Future<void> navigateToScreen(
    String screenName,
    NavigationType navigationType,
    BuildContext context, {
    Object? arguments,
    Function()? afterComplete,
  }) async {
    if (screenName == "") {
      return;
    }
    switch (navigationType) {
      case NavigationType.pushNamed:
        await GoRouter.of(
          context,
        ).pushNamed(screenName, extra: arguments).whenComplete(() {
          if (afterComplete != null) {
            afterComplete();
          }
        });
        break;

      case NavigationType.goNamed:
        GoRouter.of(context).goNamed(screenName, extra: arguments);
        break;

      case NavigationType.pushReplacementNamed:
        await GoRouter.of(
          context,
        ).pushReplacementNamed(screenName, extra: arguments);
        break;
    }
  }

  static void navigateToFirstScreen(BuildContext context) {
    while (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  static CustomTransitionPage<dynamic> _fadeTransitionScreenWrapper(
    BuildContext context,
    dynamic state,
    Widget screen,
  ) {
    return CustomTransitionPage(
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.linear).animate(animation),
              child: child,
            );
          },
      key: state.pageKey,
      child: screen,
    );
  }
}

enum NavigationType { pushNamed, goNamed, pushReplacementNamed }
