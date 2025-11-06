import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_crime_reporter/utils/theme/custom_theme/theme.dart';

import 'views/map_screen.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: VAppTheme.lightTheme,
      darkTheme: VAppTheme.darkTheme,
      home: MapScreen(userId: 'guest', callid: '928382', username: 'Guest'),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}