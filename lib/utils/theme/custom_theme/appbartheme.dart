import 'package:flutter/material.dart';

class VAppBarTheme{
  VAppBarTheme._();
  static const LightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size:24),
    actionsIconTheme:   IconThemeData(color: Colors.black,size: 24),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size:24),
    actionsIconTheme:   IconThemeData(color: Colors.white,size: 24),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white),
  );
}