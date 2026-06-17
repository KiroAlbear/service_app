import 'package:flutter/material.dart';
import 'package:service/core/services/secure_storage/secure_storage_keys.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';
import 'package:service/core/services/secure_storage/secure_storage_values.dart';
import 'core/routes/routes.dart';
import 'core/services/google_sheets_service.dart';
import 'features/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: Routes.goRouter,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      locale: const Locale('ar'),
    );
  }
}
