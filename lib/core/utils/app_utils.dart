import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../widgets/toast_widget.dart';

class AppUtils {
  // static Future<bool> isConnectedToInternet() async {
  //   final List<ConnectivityResult> connectivityResult = await (Connectivity()
  //       .checkConnectivity());
  //
  //   final bool hasNetworkConnection = connectivityResult.any(
  //     (ConnectivityResult result) => result != ConnectivityResult.none,
  //   );
  //
  //   if (!hasNetworkConnection) {
  //     return false;
  //   }
  //
  //   try {
  //     final List<InternetAddress> lookupResult = await InternetAddress.lookup(
  //       'google.com',
  //     ).timeout(const Duration(seconds: 3));
  //
  //     return lookupResult.isNotEmpty &&
  //         lookupResult.first.rawAddress.isNotEmpty;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  static void showAppToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 3),
    Color backgroundColor = Colors.red,
  }) {
    toastification.showCustom(
      context: context,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: autoCloseDuration,
      animationDuration: const Duration(milliseconds: 250),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.35),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      builder: (context, holder) {
        return ToastWidget(message: message, backgroundColor: backgroundColor);
      },
    );
  }
}
