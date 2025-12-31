import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_crime_reporter/utils/theme/custom_theme/theme.dart';
import 'package:live_crime_reporter/auth/auth_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: VAppTheme.lightTheme,
      darkTheme: VAppTheme.darkTheme,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}