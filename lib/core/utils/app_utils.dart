import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
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

  static Future<void> updateAndRestartApp(BuildContext context) async {
    final shorebirdCodePush = ShorebirdUpdater();
    // Check for updates and prompt the user to restart if one is available.
    final UpdateStatus status = await shorebirdCodePush.checkForUpdate();
    print('************** Shorebird update checking *****');
    if (status == UpdateStatus.outdated) {
      // Download the update.
      try {
        print('************** Shorebird update will be downloaded *****');

        await shorebirdCodePush.update();
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "انتبه",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "سوف يتم تطبيق التحديث الجديد عند فتح التطبيق المرة التالية",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  child: const Text("موافق"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('************** Shorebird error: $e ');
        // await DialogUtils.showAlertDialog(
        //   context: context,
        //   showConfirmButton: false,
        //   message: "An error occurred while updating the app",
        //   title: "Instant Update Error",
        //   barrierDismissible: true,
        //   buttonText: "OK",
        // );
      }
    }
  }

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
